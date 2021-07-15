import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:med_alarm/models/contact.dart';
import 'package:med_alarm/models/message.dart';

import '../../models/user.dart';
// import '../../providers/user_provider.dart';
import '../../screens/search_contact_screen.dart';
import '../../providers/firebase_provider.dart';
import '../../custom_widgets/custom_widgets.dart';

class ChatsScreen extends StatefulWidget {
  static const String id = 'CHATS_SCREEN';
  final Auth.FirebaseAuth auth = FirebaseProvider.instance.auth;

  ChatsScreen({Key key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Contact> contacts = [];
  // bool isSearching = false;

  tileEndedBuilding(uid) {
    contacts.removeWhere((element) => element.user.uid == uid);
    print('Received: ' + uid);
    print(contacts.length);
  }

  refresh() {
    setState(() {
    });
    print('refreshed..........................');
  }

  @override
  void initState() {
    super.initState();
    // FirebaseProvider.instance.login();
    // getLoggedUserInfo();
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
        child: StreamBuilder<QuerySnapshot>(
          stream:
              firestore.collection(
                  "Users/"
                  "${widget.auth.currentUser.uid}/"
                  "Contacts"
              ).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // return Container();
              return StreamBuilder(
                  stream: Stream.fromFuture(getContacts(snapshot.data.docs)),
                  builder: (ctx, ss) {
                    if(ss.hasData && ss.data.isNotEmpty) {
                      contacts = ss.data;
                      contacts.sort((a, b) => b.latestMsg.date.compareTo(a.latestMsg.date));
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
                      return Center(child: Text('No messages yet...'));
                    return Center(child: CircularProgressIndicator());
                  },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {Navigator.pushNamed(context, SearchContact.id);},
      //   backgroundColor: Theme.of(context).accentColor,
      //   child: Icon(Icons.add),
      // ),
    );
  }

  // getLoggedUserInfo() async {
  //   var value = await firestore
  //       .collection("Users")
  //       .doc(custom_widgets.widget.auth.currentUser.uid)
  //       .get();
  //   UserProvider.instance.currentUser = User.fromDoc(custom_widgets.widget.auth.currentUser.uid, value);
  // }

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
      var v1 = await firestore
          .collection('Users')
          .doc(dss.get('uid'))
          .get();
      if(!v1.exists) continue;
      var v2 = await firestore
          .collection('Messages/$msgPath/$msgPath')
          .orderBy('date', descending: true)
          .limit(1)
          .get();
      if(v2.docs.isEmpty) continue;
      contacts.add(
        Contact(
          User.fromDoc(dss.get('uid'),v1),
          Message.fromDoc(v2)),
      );

    }
    return contacts;
  }
}
