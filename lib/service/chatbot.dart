import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/providers/firebase_provider.dart';
import 'package:med_alarm/screens/chat/chatroom_screen.dart';

enum AnswersType {
  start,
  options,
  question,
  contacts,
  pages,
  error,
}

class ChatBot {
  // bool dizzy = false;
  // bool headache = false;
  // bool flu = false;
  // bool diarrhea = false;
  // bool dentalPain = false;
  // bool gumPain = false;
  // bool throatPain = false;
  // bool earPain = false;
  /*List<String> answersType = [
    'start',
    'options',
    'question',
    'contacts',
    'pages',
    'error',
  ];*/

  List<Doctor> doctors = [];
  Map<String, List<ValueText>> specialists = {};
  List<String> specialities = [];
  String selectedDoctorUid;

  final List<String> questions = [
    'Message a Specialist from your contacts',
    'Suggest a medicine (NOT HANDLED)',
    'Find nearest Pharmacies (NOT HANDLED)',
  ];

  Answer start() {
    return Answer(AnswersType.start, questions, title: 'How can i help?');
  }

  Future<Answer> query(String query, {int input}) async {
    switch(query) {
      case 'Back':
        return start();
      case 'Message a Specialist from your contacts':
        await getSpecialities();
        return Answer(
          AnswersType.options,
          List.from(specialities),
          title: 'Available specialities',
        );
      // case 'Suggest a medicine?':
      //   return Answer(
      //     AnswersType.question,
      //     ['Question 1?'],
      //   );
      // case 'Question 1?':
      //   return Answer(
      //     AnswersType.question,
      //     ['Question 2?'],
      //   );
      // case 'Question 2?':
      //   return Answer(
      //     AnswersType.question,
      //     ['Question 3?'],
      //   );
      // case 'Question 3?':
      //   return Answer(
      //     AnswersType.question,
      //     ['Question 4?'],
      //   );
    }
    if(specialities.contains(query)) {
      return Answer(
          AnswersType.contacts,
          List.from(specialists[query]),
          title: 'Available Specialists'
      );
    }
    for(int i = 0; i < doctors.length; i++) {
      if(doctors[i].uid == query)
        return Answer(
            AnswersType.pages,
            [
              ValueText(query, 'Open Chat', pageID: ChatRoom.id),
              // ValueText(query, 'Open Profile', pageID: ''),
            ],
            title: 'Dr/' + doctors[i].firstname
        );
    }
    return Answer(AnswersType.error, []);
  }

  Future getDoctor(String uid) async {
    if(doctors.isEmpty) {
      FirebaseProvider fbPro = FirebaseProvider.instance;
      var doc = await fbPro.getDoctor(uid);
      return Doctor.fromDoc(uid, doc);
    }
    return doctors.firstWhere((doctor) => doctor.uid == uid);
  }

  getSpecialities() async {
    doctors.clear();
    specialists.clear();
    specialities.clear();
    FirebaseProvider fbPro = FirebaseProvider.instance;
    var contacts = await fbPro.getContacts();
    for(int i = 0; i < contacts.docs.length; i++) {
      var doctor = await fbPro.getDoctor(contacts.docs[i].get('uid'));
      if(doctor != null) {
        doctors.add(Doctor.fromDoc(contacts.docs[i].get('uid'), doctor));
        if(!specialities.contains(doctor.get('speciality')))
          specialities.add(doctor.get('speciality'));
        if (!specialists.containsKey(doctor.get('speciality'))) {
          specialists[doctor.get('speciality')] = [];
        }
        specialists[doctor.get('speciality')].add(
            ValueText(contacts.docs[i].get('uid'), 'Dr/ ' + doctor.get('firstname'))
        );
      }
    }
  }
}

class ValueText {
  String value;
  String text;
  String pageID;
  ValueText(this.value, this.text, {this.pageID});
}

class Answer {
  AnswersType type;
  List<dynamic> list = [];
  String title = '';

  Answer(this.type, this.list, {this.title});
}
