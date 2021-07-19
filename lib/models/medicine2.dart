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
      //"dose": this.dose
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> parsedJson) {
    print('map');
    var med =  Medicine(
      medName: parsedJson['name'],
      medType: parsedJson['type'],
      startDate: DateTime.fromMillisecondsSinceEpoch(parsedJson['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(parsedJson['endDate']),
      medAmount: parsedJson['medAmount'],
      doseAmount: parsedJson['doseAmount'],
      numOfDoses: parsedJson['nDoses'],
      interval: parsedJson['interval'],
      startTime: DateTime.fromMillisecondsSinceEpoch(parsedJson['startTime']),
      intervalTime: parsedJson['intervalTime'],
      // dose: parsedJson['dose'],
    );
    print('done');
    return med;
  }
}
