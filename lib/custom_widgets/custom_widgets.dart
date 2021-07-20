import 'package:auto_direction/auto_direction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../models/contact.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../providers/firebase_provider.dart';
import '../screens/chat/chatroom_screen.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String name;
  final double bHeight;
  final double bWidth;

  const CustomButton(
      {Key key, this.callback, this.name, this.bHeight, this.bWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.all(8),
      child: Material(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(90),
        child: MaterialButton(
          padding: EdgeInsets.all(0),
          onPressed: callback,
          minWidth: 200,
          height: 50,
          child: Text(
            name,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
        ),
      ),
    );
  }
}

class MessageBox extends StatefulWidget {
  String text = '';
  bool isRTL = false;
  double textFieldHeight = 50;

  TextEditingController messagesController = TextEditingController();

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  int numLines = 1;
  int linesToShow = 1;
  int pixelsToAdd = 18;

  @override
  Widget build(BuildContext context) {
    return AutoDirection(
      onDirectionChange: (isRTL) {
        setState(() {
          widget.isRTL = isRTL;
        });
      },
      text: widget.text,
      child: TextField(
        autocorrect: false,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          hintText: 'Message',
          hintStyle: TextStyle(
            fontSize: 16,
          ),
          border: InputBorder.none,
        ),
        onChanged: (str) {
          numLines = '\n'.allMatches(str).length + 1;
          setState(() {
            widget.text = str;
            if (numLines == 1) {
              widget.textFieldHeight = 50;
            } else if (numLines == 2) {
              widget.textFieldHeight = 70;
            } else if (numLines == 3) {
              widget.textFieldHeight = 90;
            } else if (numLines == 4) {
              widget.textFieldHeight = 105;
            } else if (numLines == 5) {
              widget.textFieldHeight = 115;
            }
          });
        },
        controller: widget.messagesController,
      ),
    );
  }
}

class ContactTile extends StatefulWidget {
  final Auth.FirebaseAuth auth = FirebaseProvider.instance.auth;
  final User currentUser = UserProvider.instance.currentUser;
  final Contact contact;
  final Function refresh;

  ContactTile(this.contact, {Key key, this.refresh}) : super(key: key);
  @override
  _ContactTileState createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> {
  FirebaseProvider fbPro = FirebaseProvider.instance;
  String msgPath;
  Message msg;

  @override
  void initState() {
    super.initState();
    if (widget.auth.currentUser.uid.compareTo(widget.contact.user.uid) < 0) {
      msgPath = widget.auth.currentUser.uid + widget.contact.user.uid;
    } else {
      msgPath = widget.contact.user.uid + widget.auth.currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fbPro.getLatestMsgStream(msgPath),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.docs.isEmpty)
            return Container();
          msg = Message.fromDoc(snapshot.data);
          return FocusedMenuHolder(
            onPressed: (){},
            blurSize: 0,
            blurBackgroundColor: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                title: Text(
                  widget.contact.user.firstname + ' ' + widget.contact.user.lastname,
                ),
                subtitle: RichText(
                  maxLines: 1,
                  softWrap: false,
                  text: TextSpan(
                    style: TextStyle(color: Colors.grey),
                    children: [
                      widget.currentUser.uid == msg.from ?
                      TextSpan(text: 'You: ',
                          style: TextStyle(color: Theme.of(context).accentColor)) :
                      TextSpan(
                          text: '', style: TextStyle(color: Theme.of(context).accentColor)),
                      msg.type == 'image'?
                      TextSpan(text: '<Image>')
                          : TextSpan(text: msg.text),
                    ],
                  ),
                ),
                leading: Hero(
                  tag: widget.contact.user.uid,
                  child: (widget.contact.user.profPicURL.isEmpty) ?
                    Icon(Icons.account_circle, size: 50.0) :
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: CircleAvatar(
                        radius: 21.0,
                        backgroundImage: NetworkImage(widget.contact.user.profPicURL),
                      ),
                    ),
                ),
                trailing: Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        msg.date.substring(0, 10),
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      Text(
                        msg.date.substring(11, 16),
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatRoom(
                              otherUser: widget.contact.user,
                            ),
                      )).whenComplete(widget.refresh);
                },
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                onPressed: () async {
                  setState(() {});
                  await fbPro.deleteContact(widget.currentUser.uid, widget.contact.user.uid);
                },
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                trailingIcon: Icon(Icons.delete, color: Colors.red)
              ),
            ],
          );
        }
        return Container();
      });
  }
}

class CustomTextField extends StatefulWidget {
  double fieldHeight;
  final FocusNode fieldFocus;
  final String fieldName;
  String text;
  final bool isEmail;
  final bool isPass;
  final Function validator;
  final Function submitAction;

  CustomTextField(
      {Key key,
      this.fieldHeight,
      this.fieldName,
      this.fieldFocus,
      this.text,
      this.isEmail,
      this.isPass,
      this.validator,
      this.submitAction})
      : super(key: key);
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.fieldHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        focusNode: widget.fieldFocus,
        onChanged: (val) => widget.text = val,
        keyboardType:
            widget.isEmail ? TextInputType.emailAddress : TextInputType.name,
        obscureText: widget.isPass ? true : false,
        autocorrect: widget.isPass ? true : false,
        decoration: InputDecoration(
          hintText: widget.fieldName,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(90),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(90)),
          ),
        ),
        onFieldSubmitted: widget.submitAction,
        validator: widget.validator,
      ),
    );
  }
}
