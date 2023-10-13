import 'dart:io';

import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TestPictureScreen extends StatefulWidget {
  const TestPictureScreen({super.key});
  

  @override
  State<TestPictureScreen> createState() => _TestPictureScreenState();
}

class _TestPictureScreenState extends State<TestPictureScreen> {
  late String userName;
  late String userBio;
  //File? image;
  File? _image;
  final picker = ImagePicker();

  Future getImageFromGallery() async {
  try {
    final _image = await picker.pickImage(source: ImageSource.gallery);
    if (_image == null) return;

    setState(() => this._image = File(_image.path));
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
    // if (pickedFile != null) {
    //   _image = File(pickedFile.path);
    // }
  //);
}

//Image Picker function to get image from camera
Future getImageFromCamera() async {
  try {
    final _image = await picker.pickImage(source: ImageSource.camera);
    if (_image == null) return;

    setState(() => this._image = File(_image.path));
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}


Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Vertical scrollable layout
      body: Center(
      child: _image == null
          ? Image.file(File('assets/profile_pic_elena.png'))
          : Image.file(_image!,
                width: 75,
                height: 75,
                fit: BoxFit.fitHeight,),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: getImageFromGallery,
      tooltip: 'Pick Image',
      child: Icon(Icons.photo_library_outlined),
    ),
    );
}

}
