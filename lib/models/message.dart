import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from;
  String to;
  String fromUid;
  String toUid;
  String text;
  String date;

  Message({this.from, this.to, this.fromUid, this.toUid, this.text, this.date});

  Message.fromDoc(QuerySnapshot docs) {
    from = docs.docs[0].get('from');
    to = docs.docs[0].get('to');
    fromUid = docs.docs[0].get('from_uid');
    toUid = docs.docs[0].get('to_uid');
    text = docs.docs[0].get('text');
    date = docs.docs[0].get('date');
  }
}
