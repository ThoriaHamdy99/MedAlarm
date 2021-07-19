import 'package:flutter/material.dart';
import 'package:med_alarm/providers/firebase_provider.dart';
import 'package:med_alarm/screens/report/report_screen.dart';
import 'package:med_alarm/screens/user_profile/UserProfile.dart';

import '../main.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListView(
          children: [
            editProfileTile(context),
            Divider(height: 0,),
            measurementTile(context),
            Divider(height: 0,),
            reportTile(context),
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
      title: Text('Report'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {
        Navigator.of(context).pushNamed(ReportScreen.id);
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
