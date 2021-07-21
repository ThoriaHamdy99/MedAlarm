import 'package:flutter/material.dart';
import 'package:med_alarm/notification/localNotification.dart';
import 'package:med_alarm/providers/firebase_provider.dart';
import 'package:med_alarm/screens/report/report_screen.dart';
import 'package:med_alarm/screens/user_profile/user_profile.dart';

import '../../main.dart';
import '../sync_meds_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'More',
          style: TextStyle(
            // fontFamily: "Angel",
            // fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListView(
          children: [
            editProfileTile(context),
            Divider(height: 0,),
            syncDataTile(context),
            Divider(height: 0,),
            measurementTile(context),
            Divider(height: 0,),
            reportTile(context),
            Divider(height: 0,),
            notificationTile(context),
            Divider(height: 0,),
            logoutTile(context),
          ],
        ),
      ),
    );
  }

  ListTile editProfileTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_circle_outlined,
        size: 50,
        color: Theme.of(context).accentColor,
      ),
      title: Text('View Profile'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        Navigator.of(context).pushNamed(UserProfile.id);
      },
    );
  }

  ListTile syncDataTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.sync_outlined,
        size: 50,
        color: Theme.of(context).accentColor,
      ),
      title: Text('Syncing Data'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        Navigator.of(context).pushNamed(SyncMedsScreen.id);
      },
    );
  }

  ListTile measurementTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.analytics_outlined,
        size: 50,
        color: Theme.of(context).accentColor,
      ),
      title: Text('Measurements'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        // Navigator.of(context).pushNamed(ReportScreen.id);
      },
    );
  }

  ListTile reportTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        size: 50,
        color: Theme.of(context).accentColor,
      ),
      title: Text('Reports'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        Navigator.of(context).pushNamed(ReportScreen.id);
      },
    );
  }

  ListTile notificationTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.notifications_none_outlined,
        size: 50,
        color: Theme.of(context).accentColor,
      ),
      title: Text('Notifications'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        Navigator.of(context).pushNamed(LocalNotificationScreen.id);
      },
    );
  }

  ListTile logoutTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.logout,
        size: 50,
        color: Colors.red,
      ),
      title: Text('Logout'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        FirebaseProvider.instance.logout();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
      },
    );
  }
}
