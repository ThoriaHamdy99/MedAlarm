// ignore: import_of_legacy_library_into_null_safe
import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart' as Utils
    show DateUtils;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rxdart/subjects.dart';

class Notification {

  Notification._(){
    init();
  }

  Notification.builder(Notification notification);

  init() async {
    initialize();
  }
  Future<void>initialize()async{
    AwesomeNotifications().initialize(
        '', /// app icon
        [
          NotificationChannel(
            channelKey: 'scheduled',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.cyan,
            ledColor: Colors.white,
            playSound: true,
            importance: NotificationImportance.Max,
            defaultRingtoneType: DefaultRingtoneType.Notification,

          )
        ]
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
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

  Future<void> delayNotification(int id ,String medName ) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "scheduled",
            title:'Time to take your delayed medicine.',
            body:'Take your $medName med' ,
            payload: {'uuid': 'uuid-test'},
          displayOnBackground: true,
        ),
        schedule: NotificationInterval(interval:300, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()),
        actionButtons: [
          NotificationActionButton(
              key: 'READ', label: 'Mark as read', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'snooze', label: 'Snooze', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'cancel', label: 'Cancel', autoCancel: true, buttonType:  ActionButtonType.KeepOnTop)
        ]);
  }

  Future<void> showNotificationAtScheduleTime(
      int id,String medName, DateTime scheduleTime) async {
    String timeZoneIdentifier = AwesomeNotifications.localTimeZoneIdentifier;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'scheduled',
        title: 'Time to take your medicine.',
        body:'Take your $medName med' ,
        payload: {'uuid': 'uuid-test'},
      ),
      schedule: NotificationCalendar.fromDate(date: scheduleTime,allowWhileIdle: true,),
        actionButtons: [
          NotificationActionButton(
              key: 'take', label: 'Take', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'snooze', label: 'Snooze', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'cancel', label: 'cancel', autoCancel: true,buttonType:  ActionButtonType.KeepOnTop)
        ]);
  }
  Future<void> showNotificationRenew(int id ,String medImageURl ,String medName) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "scheduled",
            title: 'Renew your Medicine.',
            body: 'Your $medName med need to renew',
            largeIcon:
            'https://image.freepik.com/vetores-gratis/modelo-de-logotipo-de-restaurante-retro_23-2148451519.jpg',
            bigPicture: medImageURl,
            notificationLayout: NotificationLayout.BigPicture,
            color: Colors.indigoAccent,
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
