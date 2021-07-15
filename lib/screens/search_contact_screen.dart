import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'chat/chatroom_screen.dart';

class SearchContact extends StatefulWidget {
  static const String id = 'SEARCH_CONTACT_SCREEN';
  final User currentUser = UserProvider.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  SearchContact({Key key}) : super(key: key);

  @override
  _SearchContactState createState() => _SearchContactState();
}

class _SearchContactState extends State<SearchContact> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
              future: widget.firestore
                  .collection('Users')
                  .where('email', isEqualTo: email)
                  .where('email', isNotEqualTo: widget.currentUser.email)
                  .get(),
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
                User user = User.fromDoc(snapshot.data.docs[0].id, snapshot.data.docs[0]);
                return StreamBuilder(
                stream: widget.firestore
                    .collection('Users/${widget.currentUser.uid}/Contacts')
                    .doc(user.uid)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if(snapshot.hasData) {
                    Widget add_rem_button;
                    if(!snapshot.data.exists) {
                      add_rem_button = IconButton(
                        icon: Icon(
                          Icons.add,
                          // size: 50,
                          color: Theme.of(context).accentColor,
                        ),
                        tooltip: 'Add to contacts',
                        onPressed: () async {
                          await widget.firestore
                              .collection('Users/${widget.currentUser.uid}/Contacts')
                              .doc(user.uid)
                              .set({
                            'uid': user.uid,
                          });
                          await widget.firestore
                              .collection('Users/${user.uid}/Contacts')
                              .doc(widget.currentUser.uid)
                              .set({
                            'uid': widget.currentUser.uid,
                          });
                          print('done');
                        },
                      );
                    }
                    else {
                      add_rem_button = IconButton(
                        icon: Icon(
                          Icons.remove,
                          // size: 50,
                          color: Colors.red,
                        ),
                        tooltip: 'Remove from contacts',
                        onPressed: () async {
                          await widget.firestore
                              .collection(
                              'Users/${widget.currentUser.uid}/Contacts')
                              .doc(user.uid)
                              .delete();
                          await widget.firestore
                              .collection('Users/${user.uid}/Contacts')
                              .doc(widget.currentUser.uid)
                              .delete();
                          print('done');
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
                            child: user.profPicURL.isEmpty ? Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Theme.of(context).accentColor,
                            ):
                            Image.network(user.profPicURL),
                          ),
                          trailing: add_rem_button,
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
