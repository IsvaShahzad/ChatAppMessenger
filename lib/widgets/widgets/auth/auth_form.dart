import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../../screens/chat_screen.dart';
import '../pickers/image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
      String email,
      String password,
      String username,
      File image,
      bool isLogin,
      ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  late var _userEmail;
  late var _userName;
  late var _userPassword;
  late File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile=image;
  }

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
        // _isLoading = true;
      });
      if (isLogin) {
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);

        print(authResult);
        print("email: "+email);
        print("password: "+password);

      } else {
        authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
        // _isLoading = false;
      });
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();

    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please upload an image!"),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState?.save();

      try {
        // Call the authentication method (assuming widget.submitFn is an authentication method)
        _submitAuthForm(_userEmail,_userPassword,_userName,_userImageFile,_isLogin);

        // If user is signing up, navigate to the ChatScreen
        if (!_isLogin) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ChatScreen(),
            ),
          );
        }
      } catch (error) {
        // Handle authentication error, if any
        print('Authentication failed: $error');
        // You can show an error message to the user if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!_isLogin)
                    ImagePickerMine(_pickedImage),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value!.contains('@')) {
                        return 'Please enter valid email!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value!.length < 4) {
                          return 'Password must be atleast 4 characters long!';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value!.length < 7) {
                        return 'Password must be atleast 7 characters long!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 40),
                          maximumSize: const Size(150, 40),
                        ),
                        onPressed:() {
                          _trySubmit();
                          },
                        child: Text(_isLogin ? 'Login' : 'Signup')),
                  if (!widget.isLoading)
                    TextButton(
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.pink,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
