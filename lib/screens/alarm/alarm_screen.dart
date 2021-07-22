import 'package:flutter/material.dart';
import 'package:med_alarm/service/alarm.dart';

import '../../main.dart';
import '../home_screen.dart';

class AlarmScreen extends StatefulWidget {
  final Map map;

  AlarmScreen(this.map);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  @override
  void dispose() {
    Alarm.snoozeAlarm(widget.map);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Map Content=================================');
    // for(var key in widget.map.keys) {
    //   print(widget.map[key]);
    // }
    // print('============================================');
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
        title: Text('Alarm'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if(Navigator.of(navigatorKey.currentContext).canPop())
              Navigator.of(navigatorKey.currentContext).pop();
            else
              Navigator.of(navigatorKey.currentContext).pushReplacementNamed(HomeScreen.id);
          },
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.map['name'],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).accentColor,
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dose amount:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // '',
                      widget.map['doseAmount'],
                      style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // '',
                      widget.map['description'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildButton(context, 'Take', () async {await Alarm.confirmAlarm(widget.map);}),
                  buildButton(context, 'Snooze', () async {await Alarm.snoozeAlarm(widget.map);}),
                  buildButton(context, 'Cancel', () async {await Alarm.skipAlarm(widget.map);}),
                ],
              ),
              // SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(context, text, callback) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      color: text == 'Cancel' ? Colors.red : Theme.of(context).accentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onTap: () async {
          if(text == 'Cancel')
            await confirmDialog(context, callback);
          else {
            await callback();
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  confirmDialog(context, callback) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          title: Text(
            "Cancel Alarm",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Are you sure you want to cancel this dose?",
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                )),
            FlatButton(
                onPressed: () async {
                  await callback();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                )),
          ],
        );
      });
  }
}
