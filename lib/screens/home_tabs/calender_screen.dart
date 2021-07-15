import 'package:flutter/material.dart';
import 'package:med_alarm/screens/medicine/med_details.dart';
import '/main.dart';
import '/providers/firebase_provider.dart';
import '/providers/user_provider.dart';
import '/models/med_Info.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const id = "CALENDAR_SCREEN";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

Map<DateTime, List<Event>> allEvents = {};

class _CalendarScreenState extends State<CalendarScreen> {
  ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  final firstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final lastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  // bool _check = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return allEvents[day] == null ? [] : allEvents[day];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if(!isSameDay(selectedDay, _selectedDay)){
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }

  }

  @override
  Widget build(BuildContext context) {
    String hello = "Hello ";
    if(UserProvider.instance.currentUser.type == 'Doctor') hello += 'Dr/';
    hello += UserProvider.instance.currentUser.firstname;
    return Scaffold(
      appBar: AppBar(
        title: Text(hello),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(children: [
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8),
                  Text('Logout')
                ]),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseProvider.instance.logout();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyApp(),
                ));
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
              allEvents.isEmpty
                  ? Expanded(
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
                          // setState(() {
                          //   allEvents[_selectedDay] = [Event("Med2")];
                          //   print(allEvents);
                          // });
                          Navigator.of(context).pushNamed(MedDetails.id);
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
              )
                  : ( allEvents[_selectedDay] != null
                  ? Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
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
                                "8.00 AM",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12.0),
                                elevation: 5,
                                shadowColor: Colors.green,
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                  onTap: () =>
                                      print('${value[index]}'),
                                  title: InkWell(
                                    onTap: (){
                                      return Container(
                                        color: Colors.blue,
                                        alignment: Alignment.center,
                                        child: Text("meddd"),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${value[index]}',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text('${value[index]}'),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
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
              )
                  : Expanded(
                child: Container(
                  color: Color.fromRGBO(224, 240, 228, 0.5),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "No meds Today",
                      style: TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ))
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
        visible: allEvents.isEmpty ? false : true,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(MedDetails.id);
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, String text) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      title: Text(
        text,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
