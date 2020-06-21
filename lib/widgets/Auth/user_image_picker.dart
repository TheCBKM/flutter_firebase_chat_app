import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File _image) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image = null;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _image = File(pickedFile.path);
    });

    widget.imagePickFn(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: _image == null ? null : FileImage(_image),
          radius: 40.0,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: getImage,
            icon: Icon(Icons.image),
            label: Text("Add Image"))
      ],
    );
  }
}
