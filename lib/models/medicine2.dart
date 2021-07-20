import 'package:cloud_firestore/cloud_firestore.dart';

import 'dose.dart';

class Medicine {
  int id;
  String medName;
  String medType;
  DateTime startDate;
  DateTime endDate;
  int medAmount;
  int doseAmount;
  String interval;
  int intervalTime;
  DateTime startTime;
  int numOfDoses;
  String description;
  List<Dose> doses;

  Medicine({
    this.id,
    this.medName,
    this.medType,
    this.startDate,
    this.endDate,
    this.medAmount,
    this.doseAmount,
    this.startTime,
    this.interval,
    this.numOfDoses,
    this.intervalTime,
    this.description,
    this.doses
  });

  // String get getName => medicineName;
  // int get getDosage => dosage;
  // String get getType => medicineType;
  // int get getInterval => interval;
  // String get getStartTime => startTime;
  // List<dynamic> get getIDs => notificationIDs;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": medName,
      "type": medType,
      "start": startDate,
      "end": endDate,
      "medAmount": medAmount,
      "doseAmount": doseAmount,
      "nDoses": numOfDoses,
      "startTime": startTime,
      "interval": interval,
      "intervalTime": intervalTime,
      "description": description,
      //"doses": this.doses
    };
  }

  factory Medicine.fromMap(map) {
    var med =  Medicine(
      id: map['id'],
      medName: map['name'],
      medType: map['type'],
      medAmount: map['medAmount'],
      doseAmount: map['doseAmount'],
      numOfDoses: map['nDoses'],
      interval: map['interval'],
      intervalTime: map['intervalTime'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      description: map['description'],
      // doses: parsedJson['doses'],
    );
    return med;
  }

  Map<String, dynamic> toDoc() {
    return {
      "id": id,
      "name": medName,
      "type": medType,
      "start": Timestamp.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch),
      "end": Timestamp.fromMillisecondsSinceEpoch(endDate.millisecondsSinceEpoch),
      "medAmount": medAmount,
      "doseAmount": doseAmount,
      "nDoses": numOfDoses,
      "startTime": Timestamp.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch),
      "interval": interval,
      "intervalTime": intervalTime,
      "description": description,
      //"doses": this.doses
    };
  }

  factory Medicine.fromDoc(doc) {
    var med =  Medicine(
      id: doc.get('id'),
      medName: doc.get('name'),
      medType: doc.get('type'),
      medAmount: doc.get('medAmount'),
      doseAmount: doc.get('doseAmount'),
      numOfDoses: doc.get('nDoses'),
      interval: doc.get('interval'),
      intervalTime: doc.get('intervalTime'),
      startDate: DateTime.fromMillisecondsSinceEpoch(doc.get('startDate').millisecondsSinceEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(doc.get('endDate').millisecondsSinceEpoch),
      startTime: DateTime.fromMillisecondsSinceEpoch(doc.get('startTime').millisecondsSinceEpoch),
      description: doc.get('description'),
    );
    return med;
  }
}
