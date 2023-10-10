import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: butterfly,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(
                          'assets/profile_pic_elena.png'), // TODO: REPLACE WITH USER IMAGE
                    ),
                  ),
                ),
              ),

              // Change profile picture buttons
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // OPEN CAMERA
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
                ],
              ),

              // TODO: PUT EDITABLE NAME, BIO, ECT HERE
            ],
          ),
        ],
      ),
    );
  }
}
