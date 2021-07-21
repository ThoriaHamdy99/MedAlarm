import 'package:flutter/material.dart';
import 'package:med_alarm/screens/home_tabs/calender_screen.dart';
import 'package:med_alarm/utilities/push_notifications.dart';

import 'chat/chats_screen.dart';
import 'home_tabs/medicine_screen.dart';
import 'home_tabs/more_screen.dart';

class HomeScreen extends StatefulWidget {
  static const id = "HOME_SCREEN";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navBarIndex = 0;

  List<Widget> _tabs = [
    CalendarScreen(),
    MedicineScreen(),
    ChatsScreen(),
    MoreScreen(),
  ];

  @override
  void initState() {
    PushNotificationsManager().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_navBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: [
          buildBottomNavigationBarItem(Icons.home, "Home"),
          buildBottomNavigationBarItem(Icons.medical_services, "Medicine"),
          buildBottomNavigationBarItem(Icons.message_rounded, "Messages"),
          buildBottomNavigationBarItem(Icons.more_horiz, "More"),
        ],
        currentIndex: _navBarIndex,
        onTap: (i) {
          setState(() {
            _navBarIndex = i;
          });
        },
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        showSelectedLabels: true,
        selectedFontSize: 14,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.shifting,
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
      label: text,
    );
  }
}
