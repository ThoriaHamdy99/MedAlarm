import 'package:flutter/material.dart';
import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/med_details.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class CalendarScreen extends StatefulWidget {
  static const id = "CALENDAR_SCREEN";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

List<Medicine> allMeds = [];

class _CalendarScreenState extends State<CalendarScreen> {
  SQLHelper _sqlHelper = SQLHelper.getInstant();
  ValueNotifier<List<Medicine>> _selectedMeds = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  final firstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 5, DateTime.now().day);
  final lastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 5, DateTime.now().day);

  // bool _check = false;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    _selectedMeds.value = _getEventsForDay(_selectedDay);
    super.initState();
  }

  @override
  void dispose() {
    _selectedMeds.dispose();
    super.dispose();
  }

  List<Medicine> _getEventsForDay(DateTime day) {
    List<Medicine> allMedsForDay = [];
    for (int i = 0; i < allMeds.length; ++i) {
      if (allMeds[i].startDate.difference(day).inDays <= 0
        && day.difference(allMeds[i].endDate).inDays <= 0) {
        if (allMeds[i].interval == 'daily')
          allMedsForDay.add(allMeds[i]);
        else if(allMeds[i].interval == 'weekly'
          && allMeds[i].startDate.weekday == day.weekday) {
          allMedsForDay.add(allMeds[i]);
        }
        else if (allMeds[i].interval == 'monthly'
          && allMeds[i].startDate.day == day.day) {
          allMedsForDay.add(allMeds[i]);
        }
      }
    }
    return allMedsForDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDay, _selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedMeds.value = _getEventsForDay(selectedDay);
    }
  }
  
  String getTime(DateTime dateTime){
    var hours = dateTime.hour >= 0 && dateTime.hour <= 9 ? "0" + "${dateTime.hour}" : "${dateTime.hour}";
    var min = dateTime.minute >= 0 && dateTime.minute <= 9 ? "0" + "${dateTime.minute}" : "${dateTime.minute}";
    return hours + ":" + min;
  }

  @override
  Widget build(BuildContext context) {
    _selectedMeds.value = _getEventsForDay(_selectedDay);
    String hello = "";
    if (UserProvider.instance.currentUser.type == 'Doctor') hello += 'Dr/';
    hello += UserProvider.instance.currentUser.firstname;
    return Scaffold(
      appBar: AppBar(
        title: Text(hello),
        titleSpacing: 5,
        leading:
        Container(
          padding: EdgeInsets.all(5),
          child: (UserProvider.instance.currentUser.profPicURL == '') ?
            Icon(Icons.account_circle, size: 50,) :
            CircleAvatar(
              backgroundImage: NetworkImage(
                UserProvider.instance.currentUser.profPicURL,
              ),
            ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 4,
                shadowColor: Color.fromRGBO(130, 175, 0, 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: TableCalendar(
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.saturday,
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    todayDecoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              FutureBuilder<List<Medicine>>(
                  future: _sqlHelper.getAllMedicines(),
                  builder: (ctx, snapShot) {
                    if (snapShot.hasData) {
                      if (snapShot.data.isEmpty) {
                        return Expanded(
                          child: Container(
                            color: Color.fromRGBO(224, 240, 228, 0.5),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ClipRRect(
                                //     borderRadius: BorderRadius.circular(8.0),
                                //     child: Image.asset(
                                //       "assets/images/medImage2.gif",
                                //       fit: BoxFit.fill,
                                //       height: 100,
                                //     )),
                                // SizedBox(
                                //   height: 20,
                                // ),
                                Text(
                                  "Monitor your med schedule",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "No Meds Today",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RaisedButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 110),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(MedDetails.id);
                                  },
                                  child: Text(
                                    "Add Medicine",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  color: Theme.of(context).accentColor,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      //print(allMeds);
                      //print(snapShot.data.length);
                      allMeds = snapShot.data;
                      // _selectedMeds.value = _getEventsForDay(_selectedDay);
                      return _selectedMeds.value.isEmpty
                          ? Expanded(
                              child: Container(
                                color: Color.fromRGBO(224, 240, 228, 0.5),
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "No meds Today",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ValueListenableBuilder<List<Medicine>>(
                                valueListenable: _selectedMeds,
                                builder: (context, value, _) {
                                  return Container(
                                    width: double.infinity,
                                    color: Color.fromRGBO(224, 240, 228, 0.5),
                                    child: ListView.builder(
                                      itemCount: value.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "${getTime(value[index].startTime)}",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Card(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 12.0),
                                              elevation: 5,
                                              shadowColor: Colors.green,
                                              clipBehavior: Clip.antiAlias,
                                              child: ListTile(
                                                onTap: () =>
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context){
                                                          return AlertDialog(

                                                          );
                                                        }),
                                                title: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      '${value[index].medName}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text('take 1 ${value[index].medType}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                    } else if (snapShot.hasData && snapShot.data == []) {
                      return Expanded(
                        child: Container(
                          color: Color.fromRGBO(224, 240, 228, 0.5),
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ClipRRect(
                              //     borderRadius: BorderRadius.circular(8.0),
                              //     child: Image.asset(
                              //       "assets/images/medImage2.gif",
                              //       fit: BoxFit.fill,
                              //       height: 100,
                              //     )),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              Text(
                                "Monitor your med schedule",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "No Meds Today",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 110),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(MedDetails.id,
                                  arguments: {
                                        'selectedDay' : _selectedDay
                                  });
                                },
                                child: Text(
                                  "Add Medicine",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                color: Theme.of(context).accentColor,
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
          /*
          if (_check == true)
            Container(
              color: Colors.black45,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // print(allEvents);
                                allEvents[_selectedDay] = [Event("med3")];
                                // print(allEvents);
                              });
                            },
                            child: Text(
                              "Add Medicine",
                              style: TextStyle(color: Colors.black54),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white70)),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {

                            },
                            child: Text(
                              "Add Dose",
                              style: TextStyle(color: Colors.black54),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
           */
        ],
      ),
      floatingActionButton: new Visibility(
        visible: allMeds.isEmpty ? false : true,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(MedDetails.id,
                arguments: {
                  'selectedDay' : _selectedDay
                });
          },
        ),
      ),
    );
  }
}
