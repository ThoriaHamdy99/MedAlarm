import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/notification/notification.dart';
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
    //   WidgetsFlutterBinding.ensureInitialized();
    // notification.init();
  }

  @override
  void dispose() {
    AwesomeNotifications().createdSink.close();
    AwesomeNotifications().displayedSink.close();
    AwesomeNotifications().actionSink.close();
    super.dispose();
  }
String medName= "";
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
             await notification.showNotificationAtScheduleTime(
                 12, 'medName1', DateTime.now().add(Duration(seconds: 5)));

            AwesomeNotifications().displayedStream.listen((receivedNotification) {
                          FlutterRingtonePlayer.playAlarm(
                              looping: true, asAlarm: true);
                        });
            AwesomeNotifications().actionStream.listen((event) {

              if(event.buttonKeyPressed=='take')
                FlutterRingtonePlayer.stop();
              if (event.buttonKeyPressed == 'cancel')
                FlutterRingtonePlayer.stop();
              if (event.buttonKeyPressed == 'snooze') {
                FlutterRingtonePlayer.stop();
                notification.delayNotification(0, medName);
              }
            // else{
            // Navigator.of(context).pushReplacementNamed(routeName);
            // }
            });
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
