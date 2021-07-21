import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:med_alarm/models/doctor.dart';
import 'package:med_alarm/service/chatbot.dart';

import 'chatroom_screen.dart';

class ChatBotScreen extends StatefulWidget {
  static const id = 'CHAT_BOT_SCREEN';

  ChatBotScreen({Key key}) : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  ScrollController scrollController = ScrollController();
  StreamController<Widget> streamController;
  List<Widget> messages = [];
  TextEditingController messagesController = TextEditingController();
  Widget msgBox;
  ChatBot cb;
  Answer answer;

  callback(String query) async {
    Answer answer = await cb.query(query);
    if(answer.type == AnswersType.error) answer = cb.start();
    streamController.add(ChatBotMessage(cb, answer, callback));
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController.broadcast();
    streamController.stream.listen((p) =>
        setState(() => messages.insert(0, p)));
    msgBox = buildMessageBox();
    cb = ChatBot();
    answer = cb.start();
    streamController.add(ChatBotMessage(cb, answer, callback));
  }

  @override
  void dispose() {
    super.dispose();
    streamController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        elevation: 5,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'ChatBot',
              child: Container(
                height: 50,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Image.asset('./assets/chatbot.png'),
                ),
                // Icon(
                //   Icons.android,
                //   size: 50,
                //   color: Colors.white,
                // ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Chat Bot',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (ctx, index) {
                  return messages[index];
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Material(
                color: Colors.white10,
                child: Container(
                  height: 50,
                  child: answer.type == AnswersType.question ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: msgBox,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: answerQuestion,
                          child: Icon(
                            Icons.send,
                            color: Theme
                                .of(context)
                                .accentColor,
                            size: 30,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ) : Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageBox() {
    return TextField(
      autofocus: true,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        hintText: 'Answer',
        hintStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
      ),
      onEditingComplete: answerQuestion,
      controller: messagesController,
    );
  }

  answerQuestion() async {
    streamController.add(MessageBubble(messagesController.text));
    answer = await cb.query(answer.list[0], input: int.parse(messagesController.text));
    if(answer.type == AnswersType.error) answer = await cb.start();
    streamController.add(ChatBotMessage(cb, answer, callback));
    messagesController.clear();
  }
}

class MessageBubble extends StatelessWidget {
  final String text;

  MessageBubble(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(20),
            // elevation: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width * 3 / 5,
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBotMessage extends StatelessWidget {
  final ChatBot cb;
  final Answer answer;
  final Function callback;

  final bsMid = ButtonStyle(
    overlayColor: MaterialStateColor.resolveWith((states) => Colors.white54),
  );
  final bsEnd = ButtonStyle(
    overlayColor: MaterialStateColor.resolveWith((states) => Colors.white54),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          // side: BorderSide(color: Colors.red),
        )
    ),
  );
  final bsBack = ButtonStyle(
    overlayColor: MaterialStateColor.resolveWith((states) => Colors.red),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          // side: BorderSide(color: Colors.red),
        )
    ),
  );

  ChatBotMessage(this.cb, this.answer, this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(25),
            // elevation: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                    ),
                    child: answer.type == AnswersType.question ?
                      Text(answer.list[0]):
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: Colors.grey[600],
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: Text(
                              answer.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                          // Divider(color: Colors.white, thickness: 1, height: 0),
                          SizedBox(height: 7),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: answer.list.length,
                            itemBuilder: (ctx, i) {
                              var bs = bsMid;
                              if(i == answer.list.length - 1 &&
                                  answer.type == AnswersType.start) bs = bsEnd;
                              return Container(
                                // color: Theme.of(context).accentColor,
                                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Material(
                                  color: Colors.white24,
                                  // color: Theme.of(context).accentColor,
                                  child: InkWell(
                                    onTap: getButtonCallback(i, context),
                                    child: getButtonChild(i),
                                    splashColor: Theme.of(context).accentColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 7),
                          // if(answer.type != AnswersType.start)
                          //   Divider(color: Colors.white, thickness: 1,),
                          answer.type == AnswersType.start ?
                            Container():
                            Material(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              child: InkWell(
                                onTap: () async {await callback('Back');},
                                // child: Text('Back', style: TextStyle(color: Colors.white)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                  child: Text(
                                    'Back',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                                splashColor: Colors.red,
                                // hoverColor: Colors.red,
                                // highlightColor: Colors.red,
                                // overlayColor: MaterialStateColor.resolveWith((states) => Colors.red),
                                // style: ButtonStyle(
                                //   overlayColor: MaterialStateColor.resolveWith((states) => Colors.red),
                                //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                //       RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.only(
                                //             bottomLeft: Radius.circular(17),
                                //             bottomRight: Radius.circular(17),
                                //           ),
                                //           // side: BorderSide(color: Colors.red),
                                //       )
                                //   ),
                                ),
                            ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Function getButtonCallback(int i, BuildContext context) {
    return answer.type == AnswersType.options ||
        answer.type == AnswersType.start ?
    () async {await callback(answer.list[i]);}
    : answer.type == AnswersType.contacts ?
    () async {await callback(answer.list[i].value);}
    : answer.type == AnswersType.pages ?
    () async {
        Doctor doctor = await cb.getDoctor(answer.list[i].value);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChatRoom(
                    otherUser: doctor,
                  ),
            ));
      }:(){};
  }

  Widget getButtonChild(int i) {
    String text = answer.type == AnswersType.options ||
        answer.type == AnswersType.start ?
    answer.list[i]
        : answer.type == AnswersType.contacts ?
    answer.list[i].text
        : answer.type == AnswersType.pages ?
    answer.list[i].text
        :'';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      // color: Colors.cyan,
      // color: Theme.of(context).accentColor,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}
