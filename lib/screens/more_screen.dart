import 'package:flutter/material.dart';
import 'package:med_alarm/screens/report/report_screen.dart';

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
      title: Text('Edit Profile'),
      contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      onTap: () {},
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
}
