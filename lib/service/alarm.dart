import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:med_alarm/models/medicine2.dart';
import 'package:med_alarm/notification/notification.dart';
import 'package:med_alarm/utilities/sql_helper.dart';

class Alarm {
  static setAlarm(Medicine med) async {
    try {
      print(med.startDate);
      await notification.showNotificationAtScheduleTime(med);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static updateAlarm(Medicine med) async {
    try {
      await notification.cancelNotification(med.id);
    } catch (e) {
      print(e);
      throw e;
    }
    try {
      if(med.isOn) await notification.showNotificationAtScheduleTime(med);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static pauseAlarm(Medicine med) async {
    await notification.cancelNotification(med.id);
  }

  static deleteAlarm(Medicine med) async {
    await pauseAlarm(med);
  }

  static confirmAlarm(map) async {
    try {
      FlutterRingtonePlayer.stop();
    } catch (e) {}
    map['taken'] = '1';
    await SQLHelper.getInstant().replaceDose(map);
    Medicine med = Medicine.fromMapString(map);
    if(med.medAmount > 0) {
      med.medAmount -= med.doseAmount;
      print('Remaining amount: ${med.medAmount} ${med.medType}');
      await SQLHelper.getInstant().updateMedicine(med);
      switch(med.interval) {
        case 'daily':
          if(med.medAmount <= med.doseAmount * med.intervalTime) {
            print('Remaining medicine will end within a day');
            print('Medicine needs to be refilled');
            await notification.showNotificationRefill(med, '');
          }
          break;
        case 'weekly':
          if(med.medAmount <= med.doseAmount) {
            print('Remaining medicine will end next week');
            print('Medicine needs to be refilled');
          }
          break;
        case 'monthly':
          if(med.medAmount <= med.doseAmount) {
            print('Remaining medicine will end within a monthly');
            print('Medicine needs to be refilled');
          }
          break;
      }
    }
    if(med.interval != 'once') {
      // updateAlarm(med);
      await notification.showNotificationAtScheduleTime(med);
    }
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