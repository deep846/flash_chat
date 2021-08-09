import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
final _firestore = FirebaseFirestore.instance;
String loginuseremail;
class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final massegeeditcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loginuseremail = user.email;
        print(user.email);
        // print(user.displayName);
      }
    } catch (e) {
      print(e);
    }
  }
// void getmessages ()async
// {
//   final msg = await _firestore.collection('messages').get();
//   for(var msgs in msg.docs )
//     {
//       print(msgs.data());
//     }
// }

  // void getmessages() async {
  //   await for (var snap in _firestore.collection('messages').snapshots()) {
  //     for (var msgs in snap.docs) {
  //       print(msgs.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                // getmessages();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Messages(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: massegeeditcontroller,
                      onChanged: (value) {
                        //Do something with the user input.
                        messages = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if(messages != null)
                        {
                          massegeeditcontroller.clear();
                          //Implement send functionality.
                          _firestore.collection('messages').add({
                            'text': messages,
                            'sender': loginuseremail,
                            'time': FieldValue.serverTimestamp(),
                          });
                          messages = null;
                        }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Messages extends StatelessWidget {
  //const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MassegeBubble> messagebubbler=[];
        for (var massage in messages) {
          final msgtxt = massage['text'];
          final msgsender = massage['sender'];
          final messageTime = massage['time'] as Timestamp;
          final currentuser = loginuseremail;
          final msgbbl = MassegeBubble(
            txt: msgtxt,
            sender: msgsender,
            isme: currentuser == msgsender,
            time: messageTime,
          );
          messagebubbler.add(msgbbl);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding:
            EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messagebubbler,
          ),
        );
      },
    );
  }
}





class MassegeBubble extends StatelessWidget {
  //const MassegeBubble({Key? key}) : super(key: key);
  MassegeBubble({this.sender, this.txt, this.isme,this.time});
  final String sender;
  final String txt;
  final bool isme;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          time!=null?Text('$sender , ${DateFormat("MMM d , hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000))}',style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),) : Text('$sender',style: TextStyle(
    fontSize: 12.0,
    color: Colors.black54,
    ),),
          Material(
            borderRadius: isme ? BorderRadius.only(bottomLeft: Radius.circular( 30.0), bottomRight: Radius.circular( 30.0), topLeft: Radius.circular( 30.0),) :BorderRadius.only(bottomLeft: Radius.circular( 30.0), bottomRight: Radius.circular( 30.0), topRight: Radius.circular( 30.0),)  ,
            elevation: 5.0,
            color: isme ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
              child: Text('$txt',style: TextStyle(
                color: isme ? Colors.white : Colors.black54,
                fontSize: 15.0,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
