import 'package:flutter/material.dart';
import 'package:med_alarm/screens/medicine/med_details.dart';

class SyncMedsScreen extends StatelessWidget {
  static const id = 'SYNC_MEDS_SCREEN';
  const SyncMedsScreen({Key key}) : super(key: key);

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
          'Synchronize Medicines',
          style: TextStyle(
            // fontFamily: "Angel",
            // fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PanelTitle(title: 'Upload Data', isRequired: false),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildButton(context, 'Merge', () {}),
                  buildButton(context, 'Replace', () {}),
                ],
              ),
              SizedBox(height: 20,),
              PanelTitle(title: 'Download Data', isRequired: false),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildButton(context, 'Merge', () {}),
                  buildButton(context, 'Replace', () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(context, text, callback) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Material(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          onTap: callback,
        ),
      ),
    );
  }
}
