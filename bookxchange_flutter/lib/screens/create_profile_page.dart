import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late String userName = "";
  late String? userBio;

  bool checkNullValue() {
    if (userName.isEmpty) {
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Create Profile',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 50, 50, 10),
            child:
          CustomTextField(
            textField: TextField(
              onChanged: (value) {  
                userName = value;
              },
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: kTextInputDecoration.copyWith(
                  // Set the user's name
                  hintText: 'Name',
                  //contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0)
                  ),

            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
            child :SizedBox(
              width: 240, // <-- TextField width
              height: 110,
            child:
          CustomTextField(
            textField: TextField(
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {  
                userBio = value;
              },
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: kTextInputDecoration.copyWith(
                  // Set the user's name
                  hintText: 'Bio',
                  //contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0)
                  ),

            ),
          ),
          ),
          ), 
          Padding(
            //TODO: MAKE BUTTON SWITCH TO A SIGN UP BUTTON WHEN ON THE SIGN UP TAB

            padding: const EdgeInsets.fromLTRB(100, 30, 100, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: butterfly, // Set the background color to blue
                minimumSize:
                    const Size(200, 50), // Set the button size (width x height)
              ),
              onPressed: () {
                if (checkNullValue() == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: Container(
                          padding: const EdgeInsets.all(19),
                          height: 60, 
                          decoration: const BoxDecoration(
                            color: butterfly,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: const Text(
                            "Make sure to enter your name and bio!",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            )
                          )
                        ),
                    ),
                  );
                } else {
                Navigator.push(
                   context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                }
              },
              child: const Text(
                "Create Profile",
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                  fontSize: 18, // Set the text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
