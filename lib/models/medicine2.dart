import 'package:cloud_firestore/cloud_firestore.dart';

import 'dose.dart';

class Medicine {
  int id;
  String medName;
  String medType;
  String description;
  DateTime startDate;
  DateTime endDate;
  int medAmount;
  int doseAmount;
  int nDoses;
  DateTime startTime;
  String interval;
  int intervalTime;
  bool isOn;
  List<Dose> doses;
  // List<Dose> dosesSnoozed;
  // List<Dose> dosesSkipped;

  Medicine({
    this.id,
    this.medName,
    this.medType,
    this.description,
    this.startDate,
    this.endDate,
    this.medAmount,
    this.doseAmount,
    this.nDoses,
    this.startTime,
    this.interval,
    this.intervalTime,
    this.isOn,
    this.doses,
    // this.dosesSnoozed,
    // this.dosesSkipped
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
      "startDate": startDate,
      "endDate": endDate,
      "medAmount": medAmount,
      "doseAmount": doseAmount,
      "nDoses": nDoses,
      "startTime": startTime,
      "interval": interval,
      "intervalTime": intervalTime,
      "description": description,
      "isOn": isOn??true,
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
      nDoses: map['nDoses'],
      interval: map['interval'],
      intervalTime: map['intervalTime'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      description: map['description'],
      isOn: map['isOn'] == 1,
      // doses: parsedJson['doses'],
    );
    return med;
  }

  Map<String, String> toMapString() {
    return {
      "id": '$id',
      "name": medName,
      "type": medType,
      "startDate": '${startDate.millisecondsSinceEpoch}',
      "endDate": '${endDate.millisecondsSinceEpoch}',
      "medAmount": '$medAmount',
      "doseAmount": '$doseAmount',
      "nDoses": '$nDoses',
      "startTime": '${startTime.millisecondsSinceEpoch}',
      "interval": interval,
      "intervalTime": '$intervalTime',
      "description": description,
      "isOn": isOn??true ? '1' : '0',
      //"doses": this.doses
    };
  }

  factory Medicine.fromMapString(Map<String, String> map) {
    var med =  Medicine(
      id: int.parse(map['id']),
      medName: map['name'],
      medType: map['type'],
      medAmount: int.parse(map['medAmount']),
      doseAmount: int.parse(map['doseAmount']),
      nDoses: int.parse(map['nDoses']),
      interval: map['interval'],
      intervalTime: int.parse(map['intervalTime']),
      startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(map['startDate'])),
      endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(map['endDate'])),
      startTime: DateTime.fromMillisecondsSinceEpoch(int.parse(map['startTime'])),
      description: map['description'],
      isOn: map['isOn'] == '1',
      // doses: parsedJson['doses'],
    );
    return med;
  }

  Map<String, dynamic> toDoc() {
    return {
      "id": id,
      "name": medName,
      "type": medType,
      "startDate": Timestamp.fromMillisecondsSinceEpoch(startDate.millisecondsSinceEpoch),
      "endDate": Timestamp.fromMillisecondsSinceEpoch(endDate.millisecondsSinceEpoch),
      "medAmount": medAmount,
      "doseAmount": doseAmount,
      "nDoses": nDoses,
      "startTime": Timestamp.fromMillisecondsSinceEpoch(startTime.millisecondsSinceEpoch),
      "interval": interval,
      "intervalTime": intervalTime,
      "description": description,
      "isOn": isOn??true,
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
      nDoses: doc.get('nDoses'),
      interval: doc.get('interval'),
      intervalTime: doc.get('intervalTime'),
      startDate: DateTime.fromMillisecondsSinceEpoch(doc.get('startDate').millisecondsSinceEpoch),
      endDate: DateTime.fromMillisecondsSinceEpoch(doc.get('endDate').millisecondsSinceEpoch),
      startTime: DateTime.fromMillisecondsSinceEpoch(doc.get('startTime').millisecondsSinceEpoch),
      description: doc.get('description'),
      isOn: doc.get('isOn'),
    );
    return med;
  }

  List<Dose> getDosesBefore(DateTime t) {
    if(doses == null) return [];
    List<Dose> filteredDoses = [];
    for(Dose d in doses) {
      if(d.doseTime.compareTo(t) <= 0) filteredDoses.add(d);
    }
    return filteredDoses;
  }
}
