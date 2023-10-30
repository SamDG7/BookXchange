import 'dart:io';

import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

// class ImageWidget extends StatelessWidget {
//   final File image;
//   final ValueChanged<ImageSource> onClicked;

//   const ImageWidget ({
//     Key? key,
//     required this.image,
//     required this.onClicked,
//   }) : super(key: key);
// }

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String userName = '';
  late String userBio = '';
  late String userZipCode = '';
  //File? image;
  File? _image;
  final picker = ImagePicker();

  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;

  //     final imageTemporary = File(image.path);
  //     setState(() => this.image = imageTemporary);
  //   } on PlatformException catch(e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  //Image Picker function to get image from gallery
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

  bool checkNullValue() {
    if (userName.isEmpty) {
      return false;
    }
    if (userZipCode.isEmpty) {
      return false;
    }
    if (userBio.isEmpty) {
      return false;
    }
    return true;
  }

  Future<UpdateProfile>? _editProfile;
  @override
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
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: Container(
                  //children: [
                  child: CircleAvatar(
                    radius: 75,
                    //backgroundColor: butterfly,
                    child: _image == null
                        //? Image.file(File('assets/profile_pic_elena.png'))
                        ? Text(
                            'N',
                            style: TextStyle(
                              color: butterfly,
                              fontWeight: FontWeight.w500,
                              fontSize: 80,
                            ),
                          )
                        : Image.file(_image!,
                            width: 150, height: 150, fit: BoxFit.cover),
                    // child: CircleAvatar(
                    //   radius: 70,
                    //   backgroundImage: _image != null ? Image.file(_image!, fit: BoxFit.cover) as ImageProvider :  AssetImage('assets/profile_pic_elena.png'),

                    //backgroundImage:
                    // image != null
                    //   ? ClipOval(
                    //       child: Image.file(
                    //         image!,
                    //         width: 70,
                    //         height:70,
                    //         fit: BoxFit.cover,
                    //     ),
                    //AssetImage('assets/profile_pic_default.png'),
                    //_image == null ? Text('No Image selected') : Image.file(_image),
                    //) // TODO: REPLACE WITH USER IMAGE
                    //),
                  ),
                ),
              ),

              // Change profile picture buttons
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // OPEN CAMERA
                        //pickImage(ImageSource.camera);
                        getImageFromCamera();
                      },
                      icon: Icon(
                        Icons.photo_camera,
                        color: butterfly,
                      ),
                      label: Text(
                        'Open Camera',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: butterfly),
                      ),
                    ),
                  ),
                  // TODO: PUT CAMERA ROLL BUTTON HERE W SAME PADDING
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // CAMERA ROLL
                        getImageFromGallery();
                      },
                      icon: Icon(
                        Icons.photo_library,
                        color: butterfly,
                      ),
                      label: Text(
                        'Open Camera Roll',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: butterfly),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          // TODO: PUT EDITABLE NAME, BIO, ETC HERE
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    userName = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 2, color: butterfly),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: butterfly),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    userZipCode = value;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 5,
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 2, color: butterfly),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: butterfly),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "Zip Code",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: TextField(
                  onChanged: (value) {
                    userBio = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 2, color: butterfly),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: butterfly),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "Bio",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),

          SizedBox(height: 210),

          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 100),
                child: ElevatedButton(
                  //GET RID OF???
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 10, 100),
                child: ElevatedButton(
                  //TRIGGER SAVE POPUP AND EXIT
                  onPressed: () async {
                     if (checkNullValue() == false) {
                      //print("the zipcode is empty");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Make sure to fill in all the fields!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } 
                    else if ((await fetchData(userZipCode)).isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Please enter a valid zip code!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      _editProfile = updateUserProfile(
                          getUUID(), userName, userBio, userZipCode);
                      if (_image != null) {
                        saveProfilePicture(getUUID(), _image!);
                      }
                      getProfilePicture(getUUID());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Your changes have been saved!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        //Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: butterfly,
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
