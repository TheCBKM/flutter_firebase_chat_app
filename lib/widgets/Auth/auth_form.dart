import 'dart:io';

import 'package:chatapp/widgets/Auth/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final _isLoading;
  final void Function(String email, String password, String username,
      bool isLogin, File, BuildContext ctx) submitFn;

  AuthForm(this.submitFn, this._isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool isLogin = true;

  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  File _userImage = null;

  final _formKey = GlobalKey<FormState>();

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please pick an Image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          isLogin, _userImage, context);
    }
  }

  void _imagePick(File _image) {
    setState(() {
      _userImage = _image;
    });
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
                  if (!isLogin) UserImagePicker(_imagePick),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey("email"),
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email Address"),
                    onSaved: (val) {
                      _userEmail = val;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: true,
                        key: ValueKey("username"),
                        validator: (val) {
                          if (val.isEmpty || val.length < 4) {
                            return "Please enter at least 4 characters";
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: "User Name"),
                        onSaved: (val) {
                          _userName = val;
                        }),
                  TextFormField(
                      key: ValueKey("password"),
                      validator: (val) {
                        if (val.isEmpty || val.length < 7) {
                          return "Password mut be at least 7 character long";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(labelText: "Password"),
                      onSaved: (val) {
                        _userPassword = val;
                      }),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget._isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      child: widget._isLoading
                          ? CircularProgressIndicator()
                          : Text(isLogin ? "Login" : "SignUp"),
                      onPressed: _trySubmit,
                    ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(isLogin
                        ? "Create New Account"
                        : "I already have an account"),
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
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
