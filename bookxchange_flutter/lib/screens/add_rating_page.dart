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

class AddRatingScreen extends StatefulWidget {
  const AddRatingScreen({super.key});

  @override
  State<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends State<AddRatingScreen> {
  late String userRating = '';
  late String numRaters = '';

  bool isNumericString(String rating) {
    // Use a regular expression to check if the input is numeric
    return double.tryParse(rating) != null;
  }

  void successfullyAddedRating(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rating Added'),
          content: Text('You have successfully rated your match!',
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                //REDIRECT TO CHAT???
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void addRatingConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Rating of User",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to give the user that rating?", style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                successfullyAddedRating(context);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Add Rating',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Vertical scrollable layout
      body: ListView(
        children: <Widget>[
          SizedBox(height: 25),
          Center(
            child: Text(
              'Enter your rating below!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 100),
          // TODO: PUT EDITABLE NAME, BIO, ETC HERE
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    userRating = value;
                  },
                  maxLength: 4,
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
                    labelText: "Rating",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 75),
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
                     if (isNumericString(userRating) == false) {
                      //print("the zipcode is empty");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Make sure to to enter in a number!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } 
                    else if ((double.parse(userRating) < 0) || (double.parse(userRating) > 5)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Please enter a number between 0 and 5!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      //SAVE RATING HERE

                      addRatingConfirmationPopup(context);
                      /*
                      Future.delayed(Duration(seconds: 2), () {
                        //PUSH TO CHAT PAGE??
                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                        
                      });
                      */
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
