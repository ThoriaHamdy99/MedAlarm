import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/add_medicine_screen.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'package:med_alarm/screens/medicine/view_medicine_screen.dart';
import 'package:med_alarm/screens/user_profile/user_profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class CalendarScreen extends StatefulWidget {
  static const id = "CALENDAR_SCREEN";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Medicine> allMeds = [];
  SQLHelper _sqlHelper = SQLHelper.getInstant();
  ValueNotifier<List<Medicine>> _selectedMeds = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  final firstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 5, DateTime.now().day);
  final lastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 5, DateTime.now().day);

  var isSwitched = true;

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
    String dayString = day.toIso8601String().substring(0, 10);
    List<Medicine> allMedsForDay = [];
    for (int i = 0; i < allMeds.length; ++i) {
      if (allMeds[i].startDate.toIso8601String().substring(0, 10)
          .compareTo(dayString) <= 0
        && dayString.compareTo(allMeds[i].endDate
          .toIso8601String().substring(0, 10)) <= 0) {
        if (allMeds[i].interval == 'once'
            && isSameDay(allMeds[i].startDate, day))
          allMedsForDay.add(allMeds[i]);
        else if (allMeds[i].interval == 'daily') {
          // DateTime temp = DateTime.parse(DateTime.now().toIso8601String().substring(0, 10));
          // temp.add(Duration(
          //     hours: allMeds[i].startTime.hour,
          //     minutes: allMeds[i].startTime.minute
          // ));
          // int n = allMeds[i].numOfDoses;
          // allMedsForDay.add(allMeds[i]);
          // while (isSameDay(temp, day) && n > 1) {
          //   temp.add(Duration(hours: allMeds[i].intervalTime));
          //   allMeds[i].startTime.add(Duration(hours: allMeds[i].intervalTime));
          //   n--;
            allMedsForDay.add(allMeds[i]);
          // }
        }
        else if(allMeds[i].interval == 'weekly'
          && allMeds[i].startDate.weekday == day.weekday)
          allMedsForDay.add(allMeds[i]);
        else if (allMeds[i].interval == 'monthly'
          && allMeds[i].startDate.day == day.day)
          allMedsForDay.add(allMeds[i]);
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

  @override
  Widget build(BuildContext context) {
    _selectedMeds.value = _getEventsForDay(_selectedDay);
    String hello = "";
    if (UserProvider.instance.currentUser.type == 'Doctor') hello += 'Dr/';
    hello += UserProvider.instance.currentUser.firstname;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        elevation: 5,
        title: Text(
          hello,
          style: TextStyle(
            // fontFamily: "Angel",
            // fontSize: 32,
            color: Colors.white,
          ),
        ),
        titleSpacing: 5,
        leading:
        InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {Navigator.of(context).pushNamed(UserProfile.id);},
          child: Container(
            child: (UserProvider.instance.currentUser.profPicURL == '') ?
              CircleAvatar(
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: AppBar().preferredSize.height,
                ),
                backgroundColor: Colors.transparent,
              ) :
              Container(
                padding: EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    UserProvider.instance.currentUser.profPicURL,
                  ),
                ),
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
                child: buildTableCalendar(context),
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
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.asset(
                                    "assets/medicine_image1.jpg",
                                    fit: BoxFit.fill,
                                    height: 100,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
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
                                "No Medicine added",
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
                                      .pushNamed(AddMedicineScreen.id).whenComplete(() async {
                                        await updateList();
                                        // setState(() {});
                                        // _selectedMeds.value = _getEventsForDay(_selectedDay);
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
                    allMeds = snapShot.data;
                    _selectedMeds.value = _getEventsForDay(_selectedDay);
                    return _selectedMeds.value.isEmpty ?
                      Expanded(
                        child: Container(
                          color: Color.fromRGBO(224, 240, 228, 0.5),
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.asset(
                                      "assets/medicine_image1.jpg",
                                      fit: BoxFit.fill,
                                      height: 100,
                                    )),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "No medicine today",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ) :
                      Expanded(
                        child: ValueListenableBuilder<List<Medicine>>(
                          valueListenable: _selectedMeds,
                          builder: (context, value, _) {
                            _selectedMeds.value = _getEventsForDay(_selectedDay);
                            return Container(
                              width: double.infinity,
                              color: Color.fromRGBO(224, 240, 228, 0.5),
                              child: ListView.builder(
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return medCard(value[index], context);
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ],
      ),
      floatingActionButton: new Visibility(
        visible: allMeds.isEmpty ? false : true,
        child: FloatingActionButton(
          // backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.add, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pushNamed(AddMedicineScreen.id).whenComplete(() async {
              // setState(() {});
              // _selectedMeds.value = _getEventsForDay(_selectedDay);
              await updateList();
            });
          },
        ),
      ),
    );
  }

  TableCalendar<Medicine> buildTableCalendar(BuildContext context) {
    return TableCalendar(
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
        titleCentered: false,
        formatButtonShowsNext: false,
        formatButtonVisible: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  Widget medCard(Medicine med, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => ViewMedicineScreen(med)
            ),
          ).whenComplete(() async {await updateList();});
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                child: Text(
                  '${med.medName}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                child: Text('${med.doseAmount} ${med.medType}',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              if(med.description.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: Text(med.description,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),

          trailing: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              DateFormat.jm().format(med.startTime),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateList() async {
    setState(() {});
    allMeds = await _sqlHelper.getAllMedicines();
    _selectedMeds.value = _getEventsForDay(_selectedDay);
  }
}
