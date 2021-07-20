import 'package:flutter/material.dart';
import 'package:med_alarm/screens/home_tabs/calender_screen.dart';
import 'package:med_alarm/screens/more_screen.dart';
import 'package:med_alarm/screens/report/report_screen.dart';
import 'package:med_alarm/models/med_day.dart';

import 'chat/chats_screen.dart';
import 'medicine_screen.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: AppBar(
    //     title: Text(hello),
    //     actions: [
    //       DropdownButton(
    //         icon: Icon(
    //           Icons.more_vert,
    //           color: Theme.of(context).primaryIconTheme.color,
    //         ),
    //         items: [
    //           DropdownMenuItem(
    //             child: Row(children: [
    //               Icon(Icons.exit_to_app),
    //               SizedBox(width: 8),
    //               Text('Logout')
    //             ]),
    //             value: 'logout',
    //           ),
    //         ],
    //         onChanged: (itemIdentifier) {
    //           if (itemIdentifier == 'logout') {
    //             FirebaseProvider.instance.logout();
    //             Navigator.of(context).push(MaterialPageRoute(
    //               builder: (context) => MyApp(),
    //             ));
    //           }
    //         },
    //       )
    //     ],
    //   ),
      body: _tabs[_navBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        items: [
          buildBottomNavigationBarItem(Icons.home, "Home"),
          // buildBottomNavigationBarItem(Icons.notifications, "Updates"),
          buildBottomNavigationBarItem(Icons.medical_services, "Medicine"),
          buildBottomNavigationBarItem(Icons.message_rounded, "Messages"),
          // buildBottomNavigationBarItem(Icons.analytics, "Report"),
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
