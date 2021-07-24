import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dose {
  DateTime doseTime;
  bool taken;
  bool snoozed;

  Dose({
    this.doseTime,
    this.taken,
    this.snoozed,
  });

  factory Dose.fromMap(map) {
    return Dose(
      doseTime: DateTime.fromMillisecondsSinceEpoch(map['doseTime']),
      taken: map['taken'] == 1 ? true : false,
      snoozed: map['snoozed'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'doseTime': doseTime.millisecondsSinceEpoch,
      'taken': taken ? 1 : 0,
      'snoozed': snoozed ? 1 : 0,
    };
  }

  factory Dose.fromDoc(doc) {
    return Dose(
      doseTime: DateTime.fromMillisecondsSinceEpoch(doc.get('doseTime').millisecondsSinceEpoch),
      taken: doc.get('taken') == 1,
      snoozed: doc.get('snoozed') == 1,
    );
  }

  Map<String, dynamic> toDoc() {
    return {
      'doseTime': Timestamp.fromMillisecondsSinceEpoch(
          doseTime.millisecondsSinceEpoch),
      'taken': taken,
      'snoozed': snoozed,
    };
  }
}
