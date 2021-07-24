import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:med_alarm/main.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/screens/alarm/alarm_screen.dart';
import 'package:med_alarm/service/alarm.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

Notification notification = Notification();

class Notification {

  Notification();

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
              channelKey: 'Medicine Alarm',
              channelName: 'Medicine Alarm',
              channelDescription: 'Notification channel for medicine alarm',
              defaultColor: Colors.cyan,
              ledColor: Colors.white,
              importance: NotificationImportance.Max,
              defaultRingtoneType: DefaultRingtoneType.Alarm,
              // playSound: true,
              locked: true,
            ),
            NotificationChannel(
              channelKey: 'Refill Alarm',
              channelName: 'Refill Alarm',
              channelDescription: 'Notification channel for refill alarm',
              defaultColor: Colors.cyan,
              ledColor: Colors.white,
              importance: NotificationImportance.Max,
              defaultRingtoneType: DefaultRingtoneType.Alarm,
              // playSound: true,
              locked: true,
            ),
          ]
      );
      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
      // AwesomeNotifications().removeChannel('scheduled');
    } catch (e) {
      print(e);
    }

    try {
      AwesomeNotifications().displayedStream.listen((receivedNotification) {
        FlutterRingtonePlayer.playAlarm(looping: true, asAlarm: true);
      });
      AwesomeNotifications().actionStream.listen((event) async {
        var map = event.payload;
        print(event.channelKey);
        print(event.buttonKeyPressed);
        switch (event.channelKey) {
          case 'Medicine Alarm':
            switch (event.buttonKeyPressed) {
              case 'Take':
                print('Taken');
                print(map['taken']);
                Alarm.confirmAlarm(map);
                break;

              case 'Snooze':
                print('Snoozed');
                print(map['snoozed']);
                Alarm.snoozeAlarm(map);
                break;

              case 'Cancel':
                print('Cancelled');
                print(map['taken']);
                Alarm.skipAlarm(map);
                break;

              default:
                print('Else');
                if (navigatorKey == null) main();
                navigatorKey.currentState.push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return AlarmScreen(map);
                    })
                );
            } break;
          case 'Refill Alarm':
            FlutterRingtonePlayer.stop();
            switch (event.buttonKeyPressed) {
              case 'Confirm':
                print('Confirmed');
                break;

              case 'Snooze':
                print('Snoozed');
                break;

              default:
                print('Else');
                // if (navigatorKey == null) main();
                // navigatorKey.currentState.push(
                //     MaterialPageRoute(builder: (BuildContext context) {
                //       return AlarmScreen(map);
                //     })
                // );
            } break;
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
            channelKey: 'Medicine Alarm',
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
    print('here');
    DateTime scheduleTime = DateTime(med.startDate.year, med.startDate.month,
        med.startDate.day, med.startTime.hour, med.startTime.minute);
    print('here 2');
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
          // scheduleTime = scheduleTime.add(Duration(hours: med.intervalTime));
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
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: med.id,
          channelKey: 'Medicine Alarm',
          title: 'Time to take your medicine.',
          body: '${med.medName}: ${med.doseAmount} ${med.medType}',
          payload: payload,
          // autoCancel: false,
          // displayedDate: '${scheduleTime.millisecondsSinceEpoch}',
          // ticker: 'ticker',
        ),
        schedule: NotificationCalendar.fromDate(
            date: scheduleTime, allowWhileIdle: true),
        actionButtons: [
          NotificationActionButton(
              key: 'Take', label: 'Take', autoCancel: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'Snooze', label: 'Snooze', autoCancel: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'Cancel', label: 'Cancel', autoCancel: true,
              buttonType: ActionButtonType.KeepOnTop)
        ],
      );

      print('Alarm for ${med.medName} is set '
          'at ${DateFormat().add_Hms().format(scheduleTime)} '
          'on ${DateFormat().add_yMMMd().format(scheduleTime)}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> showNotificationRefill(Medicine med, String msg) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        channelKey: "Refill Alarm",
        id: med.id,
        title: '${med.medName} needs to be refilled',
        body: 'Only ${med.medAmount} ${med.medType} left',
        notificationLayout: NotificationLayout.Default,
        // largeIcon: '',
        // bigPicture: medImageURl,
        // notificationLayout: NotificationLayout.BigPicture,
        color: Colors.cyan,
        payload: {'uuid': 'uuid-test'},
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'Confirm', label: 'Confirm', autoCancel: true,
            buttonType:  ActionButtonType.KeepOnTop),
        NotificationActionButton(
            key: 'Snooze', label: 'Snooze to next dose', autoCancel: true,
            buttonType:  ActionButtonType.KeepOnTop)
      ]
    );
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

}
