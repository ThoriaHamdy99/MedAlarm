import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart' as Utils
    show DateUtils;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/main.dart';
import 'package:med_alarm/models/dose.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/alarm/alarm_screen.dart';
import 'package:med_alarm/utilities/sql_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rxdart/subjects.dart';
import 'package:table_calendar/table_calendar.dart';

class Notification {

  Notification._() {
    // init();
  }

  Notification.builder(Notification notification);

  init() async {
    await initialize();
  }
  initialize() async {
    try {
      AwesomeNotifications().initialize(
        // './assets/logo.png',
          '',
          [
            NotificationChannel(
              channelKey: 'scheduled',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for alarm',
              defaultColor: Colors.cyan,
              ledColor: Colors.white,
              importance: NotificationImportance.Max,
              defaultRingtoneType: DefaultRingtoneType.Alarm,
              locked: true,
            )
          ]
      );
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    } catch (e) {
      print(e);
    }

    try {
      AwesomeNotifications().displayedStream.listen((receivedNotification) {
        FlutterRingtonePlayer.playAlarm(looping: true, asAlarm: true);
      });
      AwesomeNotifications().actionStream.listen((event) async {
        var sqlHelper = SQLHelper.getInstant();
        var map = event.payload;
        if (event.buttonKeyPressed == 'Take') {
          FlutterRingtonePlayer.stop();
          print('Taken');
          print(map['taken']);
          map['taken'] = '1';
          await sqlHelper.replaceDose(map);
        }
        else if (event.buttonKeyPressed == 'Snooze') {
          print('Snoozed');
          FlutterRingtonePlayer.stop();
          print(map['snoozed']);
          // print('Map Content=================================');
          // for(var key in map.keys) {
          //   print(map[key]);
          // }
          // print('============================================');
          map['snoozed'] = '1';
          await sqlHelper.replaceDose(map);
          await delayNotification(map);
        }
        else if (event.buttonKeyPressed == 'Cancel') {
          print('Cancelled');
          FlutterRingtonePlayer.stop();
          print(map['taken']);
          map['taken'] = '0';
          await sqlHelper.replaceDose(map);
        }
        else{
          print('Else');
          // FlutterRingtonePlayer.stop();
          navigatorKey.currentState.push(
              MaterialPageRoute(builder: (BuildContext context) {
                return AlarmScreen(map);
              })
          );
        }
      });
    } catch(e) {
      print(e);
    }
    print('Notification Initialized..........................');
  }

  Future<DateTime> pickScheduleDate(BuildContext context, {@required bool isUtc}) async {
    TimeOfDay timeOfDay;
    DateTime now = isUtc ? DateTime.now().toUtc() : DateTime.now();
    DateTime newDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: now.add(Duration(days: 365)));

    if (newDate != null) {
      timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now.add(Duration(minutes: 1))),
      );

      if (timeOfDay != null) {
        return isUtc ?
        DateTime.utc(newDate.year, newDate.month, newDate.day, timeOfDay.hour, timeOfDay.minute) :
        DateTime(newDate.year, newDate.month, newDate.day, timeOfDay.hour, timeOfDay.minute);
      }
    }
    return null;
  }

  Future<void> delayNotification(map) async {
    // print('Map Content Delayed ========================');
    // for(var key in map.keys) {
    //   print('key: $key');
    //   print(map[key]);
    // }
    // print('============================================');
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: int.parse(map['id']),
            channelKey: 'scheduled',
            title:'Time to take your delayed medicine.',
            body:'${map['name']}: ${map['doseAmount']} ${map['type']}',
            payload: map,
          displayOnBackground: true,
        ),
        schedule: NotificationInterval(interval:10, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()),
        actionButtons: [
          NotificationActionButton(
              key: 'Take', label: 'Take', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'Snooze', label: 'Snooze', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'Cancel', label: 'Cancel', autoCancel: true, buttonType:  ActionButtonType.KeepOnTop)
        ]);
  }

  Future<void> showNotificationAtScheduleTime(Medicine med) async {
    // String timeZoneIdentifier = AwesomeNotifications.localTimeZoneIdentifier;
    DateTime scheduleTime = DateTime(med.startDate.year, med.startDate.month,
        med.startDate.day, med.startTime.hour, med.startTime.minute);
    DateTime breakAlarmTime = DateTime(med.endDate.year, med.endDate.month, med.endDate.day + 1);
    switch (med.interval) {
      case 'once':
        if(breakAlarmTime.isBefore(DateTime.now())) {
          return;
        }
        break;
      case 'daily':
        scheduleTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, med.startTime.hour, med.startTime.minute);
        while(scheduleTime.isBefore(DateTime.now())) {
          scheduleTime = scheduleTime.add(Duration(hours: med.intervalTime));
        }
        if(breakAlarmTime.isBefore(DateTime.now())) {
          return;
        }
        break;
      case 'weekly':
        while(scheduleTime.isBefore(DateTime.now())) {
          scheduleTime = scheduleTime.add(Duration(days: 7));
        }
        if(breakAlarmTime.isBefore(DateTime.now())) {
          return;
        }
        break;
      case 'monthly':
        while(scheduleTime.isBefore(DateTime.now())) {
          scheduleTime = scheduleTime.add(Duration(days: 30));
        }
        if(breakAlarmTime.isBefore(DateTime.now())) {
          return;
        }
        break;
    }
    Map<String, String> payload = med.toMapString();
    payload['doseTime'] = '${scheduleTime.millisecondsSinceEpoch}';
    payload['taken'] = '0';
    payload['snoozed'] = '0';
    // print('Map Content=================================');
    // for(var key in payload.keys) {
    //   print(payload[key]);
    // }
    // print('============================================');
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: med.id,
        channelKey: 'scheduled',
        title: 'Time to take your medicine.',
        body:'${med.medName}: ${med.doseAmount} ${med.medType}',
        payload: payload,
        // displayedDate: '${scheduleTime.millisecondsSinceEpoch}',
        // ticker: 'ticker',
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime, allowWhileIdle: true),
      actionButtons: [
        NotificationActionButton(
            key: 'Take', label: 'Take', autoCancel: true,
            buttonType:  ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: 'Snooze', label: 'Snooze', autoCancel: true,
            buttonType:  ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: 'Cancel', label: 'Cancel', autoCancel: true,
            buttonType:  ActionButtonType.KeepOnTop)
      ],
    );

    print('Alarm for ${med.medName} is set '
        'at ${DateFormat().add_Hms().format(scheduleTime)} '
        'on ${DateFormat().add_yMMMd().format(scheduleTime)}');
  }
  Future<void> showNotificationRefill(int id ,String medImageURl ,String medName) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "scheduled",
            title: 'Renew your Medicine.',
            body: '$medName needs to be refilled',
            // largeIcon:
            // 'https://image.freepik.com/vetores-gratis/modelo-de-logotipo-de-restaurante-retro_23-2148451519.jpg',
            // bigPicture: medImageURl,
            // notificationLayout: NotificationLayout.BigPicture,
            color: Colors.cyan,
            payload: {'uuid': 'uuid-test'}),
        actionButtons: [
          NotificationActionButton(
              key: 'read', label: 'Renew', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'delay', label: 'Remember-me later', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop)
        ]);

  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

}

Notification notification = Notification._();
