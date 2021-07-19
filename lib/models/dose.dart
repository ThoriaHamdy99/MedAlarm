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
}
