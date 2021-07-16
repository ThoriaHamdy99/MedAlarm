import 'package:flutter/material.dart';

class Dose {
  final int amountOfDose;
  final DateTime dateTime;
  final bool taken;

  Dose({
    @required this.amountOfDose,
    @required this.dateTime,
    @required this.taken,
  });
}
