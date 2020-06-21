import 'dart:io';

import 'package:chatapp/widgets/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAutForm(String email, String password, String username,
      bool isLogin, File _userImage, BuildContext ctx) async {
    AuthResult autResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        autResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        autResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = await FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(autResult.user.uid + '.jpg');
        await ref.putFile(_userImage).onComplete;
        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection("users")
            .document(autResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'password': password,
          'imageUrl': url
        });
      }
    } on PlatformException catch (err) {
      var message = "An error occurred, Please check your credentials !";
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(message),
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAutForm, _isLoading),
    );
  }
}
