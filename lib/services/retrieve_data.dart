import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RetrieveData extends StatefulWidget {
  @override
  _RetrieveDataState createState() => _RetrieveDataState();
}

class _RetrieveDataState extends State<RetrieveData> {
  @override

  Widget build(BuildContext context) {
    return Scaffold();
  }

  getUserList() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var fcmToken = data['fcmToken'];
      if(fcmToken!=null){
        // await PushNotifcationService().sendNotification(token: fcmToken, body: 'This is message');
      }

    }
  }
}
