import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/notification/notification.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class Alarm {
  static setAlarm(Medicine med) async {
    try {
      // await notification.initialize();
      // await notification.showNotificationAtScheduleTime(
      //     Medicine(id: 1,
      //       medName: 'med',
      //       doseAmount: 2,
      //       medType: 'Pills',
      //       interval: 'once',
      //       startDate: DateTime(2021, 7, 21, 14, 30),
      //       endDate: DateTime(2021, 8, 21, 14, 30),
      //       startTime: DateTime.now().add(Duration(seconds: 5)),
      //       // startTime: DateTime(2021, 7, 21, 14, 30),
      //     )
      // );

      // AwesomeNotifications().displayedStream.listen((receivedNotification) {
      //   FlutterRingtonePlayer.playAlarm(
      //       looping: true, asAlarm: true);
      // });
      // AwesomeNotifications().actionStream.listen((event) {
      //   if (event.buttonKeyPressed == 'take')
      //     FlutterRingtonePlayer.stop();
      //   if (event.buttonKeyPressed == 'cancel')
      //     FlutterRingtonePlayer.stop();
      //   if (event.buttonKeyPressed == 'snooze') {
      //     FlutterRingtonePlayer.stop();
      //     // notification.delayNotification(0, 'medName');
      //   }
      // });
    } catch (e) {
      print(e);
    }

    try {
      // print(med.id);
      // print(med.medName);
      // print(med.medType);
      // print(med.description);
      // print(med.startDate);
      // print(med.endDate);
      // print(med.medAmount);
      // print(med.doseAmount);
      // print(med.numOfDoses);
      // print(med.startTime);
      // print(med.interval);
      // print(med.intervalTime);
      await notification.showNotificationAtScheduleTime(med);

      // AwesomeNotifications().displayedStream.listen((receivedNotification) {
      //   FlutterRingtonePlayer.playAlarm(
      //       looping: true, asAlarm: true);
      // });
      // AwesomeNotifications().actionStream.listen((event) {
      //   if (event.buttonKeyPressed == 'Take')
      //     FlutterRingtonePlayer.stop();
      //   if (event.buttonKeyPressed == 'Snooze') {
      //     FlutterRingtonePlayer.stop();
      //     notification.delayNotification(med);
      //   }
      //   if (event.buttonKeyPressed == 'Cancel')
      //     FlutterRingtonePlayer.stop();
      // });
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static updateAlarm(Medicine med) {

  }

  static pauseAlarm(Medicine med) {

  }

  static deleteAlarm(Medicine med) {

  }

  static confirmAlarm(map) async {
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {}
    map['taken'] = '1';
    await SQLHelper.getInstant().replaceDose(map);
  }

  static snoozeAlarm(map) async {
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {}
    map['snoozed'] = '1';
    await SQLHelper.getInstant().replaceDose(map);
    await notification.delayNotification(map);
  }

  static skipAlarm(map) async {
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {}
    map['taken'] = '0';
    await SQLHelper.getInstant().replaceDose(map);
  }
}