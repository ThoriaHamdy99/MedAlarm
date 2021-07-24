import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/models/patient.dart';
import 'package:med_alarm/utilities/firebase_provider.dart';

import '../models/user.dart';
import '../utilities/user_provider.dart';
import 'home_tabs/chat/chatroom_screen.dart';

class SearchContact extends StatefulWidget {
  static const String id = 'SEARCH_CONTACT_SCREEN';
  final User currentUser = UserProvider.instance.currentUser;
  SearchContact({Key key}) : super(key: key);

  @override
  _SearchContactState createState() => _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  FirebaseProvider fbPro = FirebaseProvider.instance;
  String email = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          centerTitle: true,
          elevation: 5,
          title: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
              suffixIcon: Icon(Icons.search, color: Colors.white),
              hintText: 'Search by Email',
              hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
              border: InputBorder.none,
            ),
            onChanged: (val) {
              setState(() {
                email = val.trim();
              });
            },
          ),
        ),
        body: SafeArea(
          child: email.isEmpty?
            Container():
            FutureBuilder(
              future: fbPro.searchEmailExcept(email, widget.currentUser.email),
                builder: (ctx, snapshot) {
              if(snapshot.hasData) {
                if(snapshot.data.size==0) {
                  return Center(
                    child: Text(
                      'Not Found !!',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                User user;
                if(snapshot.data.docs[0].get('type') == 'Patient')
                  user = Patient.fromDoc(snapshot.data.docs[0].id, snapshot.data.docs[0]);
                else if(snapshot.data.docs[0].get('type') == 'Doctor')
                  user = Doctor.fromDoc(snapshot.data.docs[0].id, snapshot.data.docs[0]);
                return StreamBuilder(
                stream: fbPro.getContactFromUser(widget.currentUser.uid, user.uid),
                builder: (ctx, snapshot) {
                  if(snapshot.hasData) {
                    Widget addRemButton;
                    if(!snapshot.data.exists) {
                      addRemButton = IconButton(
                        icon: Icon(
                          Icons.add,
                          // size: 50,
                          color: Theme.of(context).accentColor,
                        ),
                        tooltip: 'Add to contacts',
                        onPressed: () async {
                          await fbPro.addContact(widget.currentUser.uid, user.uid);
                        },
                      );
                    }
                    else {
                      addRemButton = IconButton(
                        icon: Icon(
                          Icons.remove,
                          // size: 50,
                          color: Colors.red,
                        ),
                        tooltip: 'Remove from contacts',
                        onPressed: () async {
                          await FirebaseProvider.instance.deleteContact(
                              widget.currentUser.uid,
                              user.uid,
                          );
                        },
                      );
                    }
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      // height: 100,
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          title: Text(
                            user.firstname + ' ' + user.lastname,
                          ),
                          // subtitle: ,
                          leading: Hero(
                            tag: user.uid,
                            child: (user.profPicURL.isEmpty) ?
                            Icon(Icons.account_circle, size: 50.0) :
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CircleAvatar(
                                radius: 21.0,
                                backgroundImage: NetworkImage(user.profPicURL),
                              ),
                            )
                          ),
                          trailing: addRemButton,
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                    otherUser: user,
                                  ),
                                ));
                          },
                        ),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                });
              }
              return Center(child: CircularProgressIndicator());
            }),
        ),
      ),
    );
  }
}
