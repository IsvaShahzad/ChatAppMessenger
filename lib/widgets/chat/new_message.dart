import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();

  var _enteredmessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredmessage,
      'createdAt': Timestamp.now(),
      'userId': user?.uid,
      'username': userData['username'],
      'userImage': userData['image_url']
    });

    _controller.clear();
    final response = await FirebaseFirestore.instance.collection('users').get();
    for (var queryDocumentSnapshot in response.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var fcmToken = data['fcmToken'];
      print(fcmToken);

      // if(fcmToken!=null){
      //   print('uid');
      //   print(FirebaseAuth.instance.currentUser?.uid);
      //   print("doc id");
      //   print(queryDocumentSnapshot.id);
      //
      //
      //   //you have a new message will be printed for the avaialble users in the database
      //
      //   if(FirebaseAuth.instance.currentUser?.uid!=queryDocumentSnapshot.id)
      //   await PushNotifcationService().sendNotification(token: fcmToken, body: 'You have new message ${_enteredmessage}');
      // }
      // if(fcmToken!=null){
      //   await PushNotifcationService().sendNotification(token: fcmToken, body: 'This is message');
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message .....'),
                onChanged: (value) {
                  setState(() {
                    _enteredmessage = value;
                  });
                },
              )),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredmessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
