import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void messagesStreams() async {
  //   await for (var snapshot in _firestore.collection('Mesajlar').snapshots()) {
  //     for (var mesasage in snapshot.docs) {
  //       print(mesasage.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9c2727),
        title: Row(
          children: [
            Image.asset('images/app_icon.png', height: 25),
            SizedBox(width: 10),
            Text('Topkapi')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              //messagesStreams();
              _auth.signOut();
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xff9c2727),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Mesaj Yaz...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('Mesajlar').add({
                        'mesaj': messageText,
                        'sender': signedInUser.email,
                        'time': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Gonder',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Mesajlar').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<messageLine> messageWidgets = [];

        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.blue,
          ));
        }

        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('mesaj');
          final messageSender = message.get('sender');
          final currentUser = signedInUser.email;

          final messageWidget = messageLine(
            sender: messageSender,
            mesaj: messageText,
            isMe: currentUser == messageSender,
          );

          messageWidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class messageLine extends StatelessWidget {
  const messageLine({this.mesaj, this.sender, required this.isMe, Key? key})
      : super(key: key);

  final String? sender;
  final String? mesaj;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender',
              style: TextStyle(fontSize: 12, color: Color(0xff9c2727))),
          Material(
            elevation: 5,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? Color.fromARGB(255, 95, 94, 94) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$mesaj',
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
