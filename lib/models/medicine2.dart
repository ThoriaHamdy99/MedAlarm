import 'dose.dart';

class Medicine {
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
  List<Dose> doses;

  Medicine({
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
      "name": this.medName,
      "type": this.medType,
      "start": this.startDate,
      "end": this.endDate,
      "medAmount": this.medAmount,
      "doseAmount": this.doseAmount,
      "nDoses": this.numOfDoses,
      "startTime": this.startTime,
      "interval": this.interval,
      "intervalTime": this.intervalTime,
      //"doses": this.doses
    };
  }

  factory Medicine.fromMap(map) {
    var med =  Medicine(
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
      // doses: parsedJson['doses'],
    );
    return med;
  }
}
