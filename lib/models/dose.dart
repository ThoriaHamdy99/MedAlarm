import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dose {
  DateTime dateTime;
  bool taken;

  Dose({
    this.dateTime,
    this.taken,
  });

  factory Dose.fromMap(map) {
    return Dose(
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      taken: map['taken'] == 1 ? true : false,
    );
  }

  Map toMap() {
    return {
      'dateTime': dateTime.millisecondsSinceEpoch,
      'taken': taken ? 1 : 0,
    };
  }

  factory Dose.fromDoc(doc) {
    return Dose(
      dateTime: DateTime.fromMillisecondsSinceEpoch(doc.get('dateTime').millisecondsSinceEpoch),
      taken: doc.get('taken'),
    );
  }

  Map toDoc() {
    return {
      'dateTime': Timestamp.fromMillisecondsSinceEpoch(
          dateTime.millisecondsSinceEpoch),
      'taken': taken,
    };
  }
}
