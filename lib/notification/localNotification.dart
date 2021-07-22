import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/main.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/notification/notification.dart';
import 'package:med_alarm/screens/alarm/alarm_screen.dart';
// import 'package:notification/notification.dart';

class LocalNotificationScreen extends StatefulWidget {
  static const id = 'LOCAL_NOTIFICATION_SCREEN';

  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
    // try{
    //   notification.initialize();
    // } catch (e) {}
  }

  @override
  void dispose() {
    // AwesomeNotifications().createdSink.close();
    // AwesomeNotifications().displayedSink.close();
    // AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  String medName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notify'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            /// for delete med
            // // await notification.cancelNotification(0);

            /// for schedule and delay notification
            /// await notification.delayNotification(0, 'panadol');
            //   DateTime? pickedDate = await notification.pickScheduleDate(context, isUtc:false);

            // try {
            //   AwesomeNotifications()
            //       .displayedStream
            //       .listen((receivedNotification) {
            //     FlutterRingtonePlayer.playAlarm(
            //         looping: true, asAlarm: true);
            //   });
            //   AwesomeNotifications().actionStream.listen((event) {
            //     FlutterRingtonePlayer.stop();
            //     if (event.buttonKeyPressed == 'Take')
            //       FlutterRingtonePlayer.stop();
            //     if (event.buttonKeyPressed == 'Cancel')
            //       FlutterRingtonePlayer.stop();
            //     if (event.buttonKeyPressed == 'Snooze') {
            //       FlutterRingtonePlayer.stop();
            //       // notification.delayNotification(0, 'medName');
            //     }
            //     // else {
            //     //   Navigator.of(context).pushReplacementNamed(routeName);
            //     // }
            //   });
            // } catch (e) {}

            // main(map: {'medName': 'Med Name'});
            // navigatorKey.currentState.push(
            //   MaterialPageRoute(builder: (BuildContext context) {
            //     return AlarmScreen({'medName': 'Med Name'});
            //   })
            // );

            // await notification.showNotificationRefill(Medicine(
            //   id: 1,
            //   medName: 'Med',
            //   doseAmount: 1,
            //   medType: 'Pills',
            //   interval: 'daily',
            //   numOfDoses: 3,
            //   intervalTime: 2,
            //   description: '',
            //   medAmount: 3,
            //   startDate: DateTime.now(),
            //   endDate: DateTime(2021, 8, 21, 14, 30),
            //   startTime: DateTime.now().add(Duration(minutes: 1)),
            //   ), '');



            await notification.showNotificationAtScheduleTime(Medicine(
              id: 1001,
              medName: 'Med',
              doseAmount: 1,
              medType: 'Pills',
              interval: 'daily',
              nDoses: 3,
              intervalTime: 2,
              description: '',
              medAmount: 3,
              startDate: DateTime.now(),
              endDate: DateTime(2021, 8, 21, 14, 30),
              startTime: DateTime.now().add(Duration(minutes: 1)),
              isOn: true
              // startTime: DateTime(2021, 7, 21, 14, 30),
            ));

            /// for Renew Notification
            // AwesomeNotifications().actionStream.listen((event) {
            //
            //   if(event.buttonKeyPressed=='read')
            //     FlutterRingtonePlayer.stop();
            //   if (event.buttonKeyPressed == 'delay'){
            //     FlutterRingtonePlayer.stop();
            //     Navigator.of(context).pushReplacementNamed(routeName);
            //   }
            // });
          },
          child: Text('SendNotification'),
        ),
      ),
    );
  }
}
