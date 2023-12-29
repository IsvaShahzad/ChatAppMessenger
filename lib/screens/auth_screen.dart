import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/widgets/auth/auth_form.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
      String email,
      String password,
      String username,
      File image,

      bool isLogin,

      )
  async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        print(authResult);
        print("email: "+email);
        print("password: "+password);

      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(authResult);
        print("email: "+email);
        print("password: "+password);
      }


      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authResult.user!.uid + '.jpg');

      await ref.putFile(image);


      // final token = await PushNotifcationService().getToken();
      // print(token);

      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user?.uid)
          .set({
        'username': username,
        'email': email,
        'image_url': url,
        'password': password,
        // 'fcmToken': token,
      });

    }
    on PlatformException catch (e) {
      String? message = 'An error occured, please check credentials';
      if (e.message != null) {
        message = e.message;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message!),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (e) {
      print(e);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
