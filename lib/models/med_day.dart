import 'medicine.dart';

class Event {
  final String title;

  const Event(this.title);
}

class MedDay {
  final DateTime day;
  List<Medicine> medInDay;

  MedDay(
    this.day,
    this.medInDay,
  );
}
