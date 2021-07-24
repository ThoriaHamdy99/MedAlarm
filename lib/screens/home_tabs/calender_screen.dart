import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/medicine/add_medicine_screen.dart';
import 'package:med_alarm/providers/user_provider.dart';
import 'package:med_alarm/screens/user_profile/user_profile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class CalendarScreen extends StatefulWidget {
  static const id = "CALENDAR_SCREEN";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  LinkedHashMap<DateTime, List<Medicine>> map;
  List<Medicine> allMeds = [
    Medicine(
        id: 1001,
        medName: 'Med 99',
        doseAmount: 1,
        medType: 'Pills',
        interval: 'once',
        nDoses: 3,
        intervalTime: 2,
        description: '',
        medAmount: 3,
        startDate: DateTime(2021, 7, 19, 14, 30),
        endDate: DateTime(2021, 8, 19, 14, 30),
        startTime: DateTime.now().add(Duration(minutes: 1)),
        isOn: true
      // startTime: DateTime(2021, 7, 21, 14, 30),
    ),
  ];
  SQLHelper _sqlHelper = SQLHelper.getInstant();
  ValueNotifier<List<Medicine>> _selectedMeds = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  final firstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 5, DateTime.now().day);
  final lastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 5, DateTime.now().day);

  bool initialized = false;

  // bool _check = false;
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

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

  _updateLinkedHashMap() {
    map = LinkedHashMap<DateTime, List<Medicine>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    for (Medicine med in allMeds) {
      if(med.startTime.isBefore(DateTime.now())) {
        List<Dose> doses = med.getDosesBefore(DateTime.now());
        for(Dose d in doses??[]) {
          Medicine m = Medicine.fromMapString(med.toMapString());
          m.startTime = d.doseTime;
          m.doses = [d];
          if(map[m.startTime] == null) map[m.startTime] = [];
          map[m.startTime].add(m);
        }
      }
      switch (med.interval) {
        case 'once':
          DateTime temp = DateTime.parse(med.startDate.toIso8601String().substring(0, 10));
          temp = temp.add(Duration(
              hours: med.startTime.hour,
              minutes: med.startTime.minute
          ));
          Medicine m = Medicine.fromMapString(med.toMapString());
          m.startTime = temp;
          if(map[temp] == null) map[temp] = [];
          map[temp].add(m);
          break;
        case 'daily':
          DateTime temp = DateTime.parse(DateTime.now().toIso8601String().substring(0, 10));
          temp = temp.add(Duration(
            hours: med.startTime.hour,
            minutes: med.startTime.minute
          ));
          int n = med.nDoses;
          while(temp.isBefore(DateTime.now()) && n > 1) {
            temp = temp.add(Duration(hours: med.intervalTime));
            n--;
          }
          if(temp.isBefore(DateTime.now())) {
            temp = DateTime.parse(DateTime.now().toIso8601String().substring(0, 10));
            temp = temp.add(Duration(
              days: 1,
              hours: med.startTime.hour,
              minutes: med.startTime.minute
            ));
          }
          while (temp.isBefore(med.endDate)) {
            Medicine m = Medicine.fromMapString(med.toMapString());
            m.startTime = temp;
            if(map[temp] == null) map[temp] = [];
            map[temp].add(m);
            temp = temp.add(Duration(hours: m.intervalTime));
          }
          break;
        case 'weekly':
          DateTime temp = DateTime.parse(med.startDate.toIso8601String().substring(0, 10));
          temp = temp.add(Duration(
              hours: med.startTime.hour,
              minutes: med.startTime.minute
          ));
          while(temp.isBefore(DateTime.now())) {
            temp = temp.add(Duration(
                days: 7
            ));
          }
          while (temp.isBefore(med.endDate)) {
            Medicine m = Medicine.fromMapString(med.toMapString());
            m.startTime = temp;
            if(map[temp] == null) map[temp] = [];
            map[temp].add(m);
            temp = temp.add(Duration(days: 7));
          }
          break;
        case 'monthly':
          DateTime temp = DateTime.parse(med.startDate.toIso8601String().substring(0, 10));
          temp = temp.add(Duration(
              hours: med.startTime.hour,
              minutes: med.startTime.minute
          ));
          while(temp.isBefore(DateTime.now())) {
            temp = temp.add(Duration(
                days: 30
            ));
          }
          while (temp.isBefore(med.endDate)) {
            Medicine m = Medicine.fromMapString(med.toMapString());
            m.startTime = temp;
            if(map[temp] == null) map[temp] = [];
            map[temp].add(m);
            temp = temp.add(Duration(days: 30));
          }
          break;
      }
    }
  }

  init() async {
    while(!initialized) {}

    setState(() {});
  }

  List<Medicine> _getEventsForDay(DateTime day) {
    _updateLinkedHashMap();
    if(map[day] == null) return [];
    map[day].sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });
    return map[day]??[];
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
      appBar: customAppBar(hello, context),
      body: Stack(
        children: [
          FutureBuilder<List<Medicine>>(
            future: _sqlHelper.getAllMedicinesAndDoses(),
            builder: (ctx, snapShot) {
              if (snapShot.hasData) {
                allMeds = snapShot.data;
                initialized = true;
                _selectedMeds.value = _getEventsForDay(_selectedDay);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: buildTableCalendar(context),
                    ),
                    const SizedBox(height: 1),
                    snapShot.data.isEmpty ?
                    buildNoMedsAll(context) :
                    _selectedMeds.value.isEmpty ?
                    buildNoMedsDay() :
                    Expanded(
                      child: ValueListenableBuilder<List<Medicine>>(
                        valueListenable: _selectedMeds,
                        builder: (context, value, _) {
                          _selectedMeds.value = _getEventsForDay(_selectedDay);
                          return medCardsBuilder(value);
                        },
                      ),
                    ),
                  ],
                );
              //   if (snapShot.data.isEmpty) {
              //     return buildNoMedsAll(context);
              //   }
              //   allMeds = snapShot.data;
              //   initialized = true;
              //   _selectedMeds.value = _getEventsForDay(_selectedDay);
              //   return _selectedMeds.value.isEmpty ?
              //     buildNoMedsDay() :
              //     Expanded(
              //       child: ValueListenableBuilder<List<Medicine>>(
              //         valueListenable: _selectedMeds,
              //         builder: (context, value, _) {
              //           _selectedMeds.value = _getEventsForDay(_selectedDay);
              //           return medCardsBuilder(value);
              //         },
              //       ),
              //     );
                }
                return Center(child: CircularProgressIndicator());
              }),
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

  AppBar customAppBar(String hello, BuildContext context) {
    return AppBar(
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
    );
  }

  Container medCardsBuilder(List<Medicine> value) {
    return Container(
      child: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          return medCard(value[index], context);
        },
      ),
    );
  }

  Expanded buildNoMedsDay() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(
                  "assets/medicine_image1.jpg",
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
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
    );
  }

  Widget buildNoMedsAll(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
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
      ),
    );
  }

  TableCalendar buildTableCalendar(BuildContext context) {
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
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${med.medName}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                if(med.startTime.isBefore(DateTime.now()))
                  buildDoseStatus(med),
                Text(
                  DateFormat.jm().format(med.startTime),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            title: Text('${med.doseAmount} ${med.medType}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('test test test test test test test ',
                // child: Text(med.description,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
                // if(med.description.isNotEmpty)
          ),
        ],
      ),
    );
  }

  Widget buildDoseStatus(Medicine med) {
    print(med.medName);
    print(med.startTime);
    bool taken = false;
    bool snoozed = false;

    if(med.doses != null && med.doses.isNotEmpty) {
      if (med.doses[0].taken) taken = true;
      if (med.doses[0].snoozed) snoozed = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(snoozed)
            Icon(Icons.snooze, color: Colors.blueAccent),
          taken ?
            Icon(Icons.check_circle_outline, color: Colors.green) :
            Icon(Icons.cancel_outlined, color: Colors.red),
        ],
      ),
    );
  }

  bool isSameTime(DateTime a, DateTime b) {
    return a.hour == b.hour && a.minute == b.minute;
  }

  updateList() async {
    setState(() {});
    allMeds = await _sqlHelper.getAllMedicines();
    _selectedMeds.value = _getEventsForDay(_selectedDay);
  }
}
