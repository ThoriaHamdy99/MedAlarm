import 'package:flutter/foundation.dart';

class ChatBot {
  bool dizzy = false;
  bool headache = false;
  bool flu = false;
  bool diarrhea = false;
  bool dentalPain = false;
  bool gumPain = false;
  bool throatPain = false;
  bool earPain = false;

  final List<String> questions = [
    'Suggest a medicine?',
    'Message a Specialist from your contacts?',
    'Find nearest Pharmacies?',
    // 'Whats is your age?',
    // '',
  ];

  Answer start() {
    return Answer(false, questions, title: 'How can i help?');
  }

  Answer query(String query, {int input}) {
    switch(query) {
      case 'Message a Specialist from your contacts?':
        return Answer(
          false,
          [
            'Contact 1',
            'Contact 2',
            'Contact 3',
            'Contact 4',
          ],
          title: 'Available contacts',
        );
      case 'Suggest a medicine?':
        print(input);
        return Answer(
          true,
          ['Question 1?'],
        );
      case 'Question 1?':
        print(input);
        return Answer(
          true,
          ['Question 2?'],
        );
      case 'Question 2?':
        print(input);
        return Answer(
          true,
          ['Question 3?'],
        );
      case 'Question 3?':
        print(input);
        return Answer(
          true,
          ['Question 4?'],
        );
    }
    return Answer(false, []);
  }

}

class Answer {
  bool needInput = false;
  List<String> list = [];
  String title = '';

  Answer(this.needInput, this.list, {this.title});
}
