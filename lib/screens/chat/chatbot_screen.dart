import 'dart:async';
import 'package:flutter/material.dart';
import 'package:med_alarm/service/chatbot.dart';

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

  callback(String query) {
    answer = cb.query(query);
    if(answer.list.isEmpty) answer = cb.start();
    streamController.add(ChatBotMessage(answer, callback));
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
    streamController.add(ChatBotMessage(answer, callback));
    // load(streamController);
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
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'ChatBot',
              child: Container(
                height: 50,
                child: Icon(
                  Icons.android,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Chat Bot',
              style: TextStyle(
                fontSize: 16,
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
                  child: answer.needInput ? Row(
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

  answerQuestion() {
    streamController.add(MessageBubble(messagesController.text));
    answer = cb.query(answer.list[0], input: int.parse(messagesController.text));
    if(answer.list.isEmpty) answer = cb.start();
    streamController.add(ChatBotMessage(answer, callback));
    messagesController.clear();
  }
}

class MessageBubble extends StatelessWidget {
  final String text;

  MessageBubble(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
  final Answer answer;
  final Function callback;

  ChatBotMessage(this.answer, this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(20),
            // elevation: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 2 / 3,
                    ),
                    child: answer.needInput ?
                      Text(answer.list[0]):
                      Column(
                        children: [
                          Text(
                            answer.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 1,),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: answer.list.length,
                            itemBuilder: (ctx, i) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).accentColor,
                                ),
                                child: TextButton(
                                  onPressed: () => callback(answer.list[i]),
                                  child: Text(answer.list[i], style: TextStyle(color: Colors.white)),
                                ),
                              );
                            },
                          ),
                          Divider(color: Colors.white, thickness: 1,),
                          answer.title != 'How can i help?' ?
                          TextButton(
                            onPressed: () => callback(''),
                            child: Text('Back', style: TextStyle(color: Colors.white)),
                          ):Container(),
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
}

class ImageViewer extends StatelessWidget {
  final String url;

  ImageViewer(this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery
            .of(context)
            .padding
            .top,
      ),
      child: Image.network(
        url,
      ),
    );
  }
}
