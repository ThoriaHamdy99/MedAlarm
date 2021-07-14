import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:med_alarm/models/user.dart';
import 'package:med_alarm/providers/user_provider.dart';

import '../../providers/firebase_provider.dart';
import '../../custom_widgets/custom_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatRoom extends StatefulWidget {
  static const String id = 'CHAT_ROOM';
  final Auth.FirebaseAuth auth = FirebaseProvider.instance.auth;
  final User currentUser = UserProvider.instance.currentUser;
  final User otherUser;

  ChatRoom({Key key, this.otherUser})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String messagesPath;
  File image;

  MessageBox msgBox = MessageBox();
  ScrollController scrollController = ScrollController();

  Future<void> sendMessage({String url}) async {
    String msg = '';
    if (msgBox.messagesController.text.length > 0) {
      msg = msgBox.messagesController.text.trim();
    } else
      try {
        if (url != null && url.isNotEmpty) {
          msg = url;
        }
      } catch (e) {}
    if (msg.isNotEmpty) {
      msgBox.text = '';
      msgBox.messagesController.clear();
      setState(() {
        msgBox.textFieldHeight = 50;
      });
      await firestore.collection('Messages/$messagesPath/$messagesPath').add({
        'from': widget.currentUser.username,
        'from_uid': widget.currentUser.uid,
        'to': widget.otherUser.username,
        'to_uid': widget.otherUser.uid,
        'text': msg,
        'date': DateTime.now().toIso8601String().toString()
      });
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 1), curve: Curves.easeOut);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.auth.currentUser.uid.compareTo(widget.otherUser.uid) < 0) {
      messagesPath = widget.auth.currentUser.uid + widget.otherUser.uid;
    } else {
      messagesPath = widget.otherUser.uid + widget.auth.currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueAccent,
        // leading: FlatButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: Icon(Icons.arrow_back),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(90)),
        //   ),
        // ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: widget.otherUser.uid,
              child: Container(
                height: 50,
                child: widget.otherUser.profPicURL.isEmpty ? Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ):
                Image.network(widget.otherUser.profPicURL),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser.firstname + ' ' + widget.otherUser.lastname,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.otherUser.username,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("Messages/$messagesPath/$messagesPath")
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<DocumentSnapshot> docs = snapshot.data.docs;
                  String prevDate;
                  List<Widget> messages = [];
                  docs.forEach((doc) {
                    if(messages.isNotEmpty)
                      if(prevDate != doc.get('date').toString().substring(0, 10))
                          messages.add(dateExtractor(prevDate));

                    messages.add(MessageBubble(
                            from: doc.get('from'),
                            text: doc.get('text'),
                            date: doc.get('date'),
                            me: widget.currentUser.username == doc.get('from')
                                ? true
                                : false));
                    prevDate = doc.get('date').toString().substring(0, 10);
                  });

                  messages.add(dateExtractor(prevDate));

                  return ListView(
                    controller: scrollController,
                    children: [...messages],
                    reverse: true,
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Material(
                color: Colors.white10,
                child: Container(
                  height: msgBox.textFieldHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: msgBox,
                        ),
                      ),
                      SizedBox(
                        width: 1,
                      ),
                      Container(
                        height: 50,
                        width: 30,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: chooseImage,
                          child: Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                            size: 30,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: sendMessage,
                          child: Icon(
                            Icons.send,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dateExtractor(date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      // mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
        Container(
          margin: EdgeInsets.all(7),
          child: Text(
            date,
            style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ],
    );
  }

  void chooseImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    if (image == null) return;
    File file = File(image.path);

    FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: 'gs://medalarm-fcai2021.appspot.com',
    );

    Reference ref =
        storage.ref('media/$messagesPath/${DateTime.now()}');
    UploadTask storageUploadTask = ref.putFile(file);
    TaskSnapshot storageTaskSnapshot =
        await storageUploadTask.whenComplete(() => null);
    String url = await storageTaskSnapshot.ref.getDownloadURL();
    sendMessage(url: url);
  }
}

class MessageBubble extends StatelessWidget {
  final String from;
  final String text;
  final String date;
  final bool me;

  const MessageBubble({Key key, this.from, this.text, this.date, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            color: me ? Theme.of(context).accentColor : Colors.grey,
            borderRadius: BorderRadius.circular(20),
            // elevation: 6,
            child: !text.contains(
                    'https://firebasestorage.googleapis.com/v0/b/medalarm-fcai2021.appspot.com')
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 7, 10, 3),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 3 / 5,
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(13, 0, 13, 5),
                          child: Text(
                            timeExtractor(date),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 7, 10, 3),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height,
                            maxWidth: MediaQuery.of(context).size.width * 3 / 5,
                            // minHeight: 25.0,
                            // minWidth: 25.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageViewer(text),
                                  ));
                            },
                            child: Image.network(
                              text,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(13, 0, 13, 5),
                          child: Text(
                            timeExtractor(date),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  String timeExtractor(String str) {
    return str.substring(11, 16);
  }
}

class ImageViewer extends StatelessWidget {
  final String url;

  ImageViewer(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Image.network(
        url,
      ),
    );
  }
}
