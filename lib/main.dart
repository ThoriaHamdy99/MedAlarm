import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_alarm/screens/home_tabs/chat/chatbot_screen.dart';
import 'package:med_alarm/screens/home_tabs/chat/chatroom_screen.dart';
import 'package:med_alarm/screens/home_tabs/chat/chats_screen.dart';
import 'package:med_alarm/service/notification.dart';
import 'package:med_alarm/screens/sync_meds_screen.dart';
import 'package:med_alarm/screens/user_profile/edit_profile.dart';
import 'package:med_alarm/service/alarm.dart';
import 'utilities/firebase_provider.dart';
import 'screens/medicine/add_medicine_screen.dart';
import 'screens/home_tabs/calender_screen.dart';
import 'screens/login_fresh/login_fresh_screen.dart';
import 'screens/report/report_screen.dart';
import 'service/scroll_behavior.dart';
import 'utilities/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_contact_screen.dart';
import 'utilities/sql_helper.dart';
import 'models/user.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await notification.initialize();
    Alarm.insureAlarmsAreOn();
    WidgetsFlutterBinding.ensureInitialized();

    await SQLHelper.getInstant().insertDummyData();
    await SQLHelper.getInstant().getLastWeekDoses(97);
  } catch (e) {
    print(e);
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {runApp(MyApp());});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med Alarm',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        primaryIconTheme: IconThemeData(color: Colors.white),
        primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      home: _getLandingPage(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        BuildLoginFresh.id: (context) => BuildLoginFresh(),
        CalendarScreen.id: (context) => CalendarScreen(),
        SearchContact.id: (context) => SearchContact(),
        ChatRoom.id: (context) => ChatRoom(),
        ChatsScreen.id: (context) => ChatsScreen(),
        ReportScreen.id: (context) => ReportScreen(),
        AddMedicineScreen.id: (context) => AddMedicineScreen(),
        ChatBotScreen.id: (context) => ChatBotScreen(),
        EditProfile.id: (context) => EditProfile(),
        SyncMedsScreen.id: (context) => SyncMedsScreen(),
      },
    );
  }

  Widget _getLandingPage() {
    // if(widget.map != null) {
    //   return AlarmScreen(widget.map);
    // }
    return FutureBuilder<User> (
      future: SQLHelper.getInstant().getUser(),
      builder: (context, snapShot) {
        // if(Auth.FirebaseAuth.instance.currentUser == null)
        //   return Scaffold(body: BuildLoginFresh());
        if(snapShot.hasError)
          return Scaffold(body: BuildLoginFresh());
        // else if(snapShot.data == null)
        //   return Scaffold(body: BuildLoginFresh());
        else if (snapShot.hasData) {
          try {
            if (snapShot.data.email.isNotEmpty) {
            // if (Auth.FirebaseAuth.instance.currentUser.email ==
            //     snapShot.data.email) {
              // if (Users.patientUser) {
              var auth = FirebaseProvider.instance.auth;
              UserProvider.instance.currentUser = snapShot.data;
              return HomeScreen();
            }
            else if(snapShot.data == null)
              return HomeScreen();
            else
              return Scaffold(body: Center(child: CircularProgressIndicator()));
              // return Scaffold(body: BuildLoginFresh());
          } catch(e) {
            return Scaffold(body: BuildLoginFresh());
          }
        }
        else
          return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );

  }
}
