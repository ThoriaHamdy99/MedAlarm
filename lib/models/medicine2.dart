import 'package:flutter/cupertino.dart';

import 'dose.dart';

class Medicine {
  final String medName;
  final String medType;
  final DateTime startDate;
  final DateTime endDate;
  final int amountOfMed;
  final String interval;
  final int intervalTime;
  final DateTime startTime;
  final int numOfDoses;
  List<Dose> doses;

  Medicine({
    @required this.medName,
    @required this.medType,
    @required this.startDate,
    @required this.endDate,
    @required this.amountOfMed,
    this.startTime,
    this.interval,
    this.numOfDoses,
    this.doses,
    this.intervalTime,
  });

  // String get getName => medicineName;
  // int get getDosage => dosage;
  // String get getType => medicineType;
  // int get getInterval => interval;
  // String get getStartTime => startTime;
  // List<dynamic> get getIDs => notificationIDs;

  Map<String, dynamic> toJson() {
    return {
      "name": this.medName,
      "type": this.medType,
      "start": this.startDate,
      "end": this.endDate,
      "amount": this.amountOfMed,
      "numOfDoses": this.numOfDoses,
      "doses": this.doses,
      "startTime" : this.startTime,
      "interval" : this.interval,
      "intervalTime" : this.intervalTime,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      medName: parsedJson['name'],
      medType: parsedJson['type'],
      startDate: parsedJson['start'],
      endDate: parsedJson['end'],
      amountOfMed: parsedJson['amount'],
      numOfDoses: parsedJson['numOfDoses'],
      doses: parsedJson['doses'],
      interval: parsedJson['interval'],
      startTime : parsedJson['startTime'],
      intervalTime : parsedJson['intervalTime'],
    );
  }
}
