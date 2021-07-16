import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:med_alarm/custom_widgets/custom_widgets.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/models/patient.dart';
import 'package:med_alarm/models/contact.dart';
import 'package:med_alarm/models/message.dart';
import 'package:med_alarm/screens/chat/chatbot_screen.dart';
import 'package:med_alarm/screens/search_contact_screen.dart';
import 'package:med_alarm/providers/firebase_provider.dart';

class ChatsScreen extends StatefulWidget {
  static const String id = 'CHATS_SCREEN';
  final Auth.FirebaseAuth auth = FirebaseProvider.instance.auth;

  ChatsScreen({Key key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseProvider fbPro = FirebaseProvider.instance;
  List<Contact> contacts = [];

  refresh() {
    setState(() {
      // contacts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Chats',
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {
            Navigator.pushNamed(context, SearchContact.id);
          }),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: ListTile(
                leading: Hero(
                  tag: 'ChatBot',
                  child: Icon(
                    Icons.android,
                    size: 40,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                title: Text('Chat Bot', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pushNamed(context, ChatBotScreen.id);
                },
              ),
            ),
            Divider(height: 0, thickness: 1),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fbPro.getContacts(widget.auth.currentUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // return Container();
                    return StreamBuilder(
                        stream: Stream.fromFuture(getContacts(snapshot.data.docs)),
                        builder: (ctx, ss) {
                          if(ss.hasData && ss.data.isNotEmpty) {
                            contacts = ss.data;
                            contacts.sort((a, b) => b.latestMsg.date.compareTo(a.latestMsg.date));
                            print('Sorted');
                            return ListView.builder(
                              itemCount: contacts.length,
                              itemBuilder: (ctx2, i) {
                                if (i == contacts.length - 1)
                                  return ContactTile(contacts[i], refresh: refresh);
                                else
                                  return Column(
                                    children: [
                                      ContactTile(contacts[i], refresh: refresh),
                                      Container(
                                        height: 1,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 2 / 3,
                                        color: Colors.grey,
                                      )
                                    ],
                                  );
                              },
                            );
                          }
                          else if(ss.hasData && ss.data.isEmpty)
                            return Container();
                          return Center(child: CircularProgressIndicator());
                        },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getMsgPath(uid) {
    if (widget.auth.currentUser.uid.compareTo(uid) < 0) {
      return widget.auth.currentUser.uid + uid;
    } else {
      return uid + widget.auth.currentUser.uid;
    }
  }

  Future<List<Contact>> getContacts(docs) async {
    List<Contact> contacts = [];
    for(DocumentSnapshot dss in docs) {
      if(dss.id == '_init') continue;
      String msgPath = getMsgPath(dss.get('uid'));
      var v1 = await fbPro.getUser(dss.get('uid'));
      if(!v1.exists) continue;
      var v2 = await fbPro.getLatestMsg(msgPath);
      if(v2.docs.isEmpty) continue;
      if(v1.get('type') == 'Patient')
        contacts.add(
          Contact(
            Patient.fromDoc(dss.get('uid'),v1),
            Message.fromDoc(v2)),
        );
      else if(v1.get('type') == 'Doctor')
        contacts.add(
          Contact(
            Doctor.fromDoc(dss.get('uid'),v1),
            Message.fromDoc(v2)),
        );
    }
    return contacts;
  }
}
