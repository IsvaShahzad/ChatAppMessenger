import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class ImagePickerMine extends StatefulWidget {

  ImagePickerMine(this.imagePickFn);

  final void Function(File pickedImage)  imagePickFn;

  @override
  State<ImagePickerMine> createState() => _ImagePickerMineState();


}

class _ImagePickerMineState extends State<ImagePickerMine> {
  final picker = ImagePicker();
  File? _pickedImage; // Use nullable File type to indicate it can be null

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedImage == null) {
      // User canceled image selection
      print('Image selection canceled by user.');
      return;
    }

    final pickedImageFile = File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        ElevatedButton.icon(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.pink,
            elevation: 1.0,
          ),
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
