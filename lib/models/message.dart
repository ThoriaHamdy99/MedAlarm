import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from;
  String to;
  String type;
  String text;
  String url;
  String date;

  Message({this.from, this.to, this.type, this.url, this.text, this.date});

  Message.fromDoc(QuerySnapshot docs) {
    from = docs.docs[0].get('from');
    to = docs.docs[0].get('to');
    type = docs.docs[0].get('type');
    type == 'text'?
    text = docs.docs[0].get('text'):
    url = docs.docs[0].get('url');
    date = docs.docs[0].get('date');
  }
}
