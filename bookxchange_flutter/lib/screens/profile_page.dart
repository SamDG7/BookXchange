import 'dart:math';

import 'package:bookxchange_flutter/api/show_user_profile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:share/share.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

    Future<void> shareApp() async {
  // Set the app link and the message to be shared
    const String appLink = 'https://github.com/SamDG7/BookXchange';
    const String message = 'Hey! I just joined this really cool app called BookXchange! Become a member of our book-lover community and read your favorite books!';

  // Share the app link and message using the share dialog
    await FlutterShare.share(title: 'Share App', text: message, linkUrl: appLink);
}
Future<void> shareApp2() async {
  // Share the message using the share dialog
  const String message = 'Check out my profile on BookXChange!';
    await FlutterShare.share(title: 'Share App', text: message);
}

  //Future<ProfileAccount>? currentUser;
  Future<ProfileAccount> currentUser = fetchProfileAccount();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Vertical scrollable layout
      body: ListView(
        children: <Widget>[
          // Profile image, profile name, join date, edit profile button, share profile
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: butterfly,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          AssetImage('assets/profile_pic_elena.png'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Container(
                  child: Column(
                    children: [
                      Text(
                        "Elena Monroe", // TODO: REPLACE WITH USER IMAGE
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                          "Joined Oct. 1st, 2023"), // TODO: REPLACE WITH USER JOIN DATE

                      //Edit profile option
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileScreen()),
                            );
                          },
                          icon: Icon(
                            Icons.mode_edit,
                            color: butterfly,
                          ),
                          label: Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: butterfly),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                    height: 300,
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Love This App? Share The Love!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge),
                                        SizedBox(height: 20),
                                        Text(
                                            "Click any of these platforms to tell your friends you are on BookXChange!"),
                                        SizedBox(height: 50),
                                        Row(
                                          children: [
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () {
                                                shareApp();
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(butterfly),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(Size(150,
                                                        50)),
                                              ),
                                              child: Text(
                                                "Invite Friends",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                shareApp2();
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(butterfly),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(Size(150,
                                                        50)),
                                              ),
                                              child: Text(
                                                "Share Profile",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )));
                          },
                          icon: Icon(
                            Icons.share,
                            color: butterfly,
                          ),
                          label: Text(
                            'Share',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 1.0, color: butterfly),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // About me title and bio
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About Me:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                  child: Text(
                    "Hello! My name is Elena and I live in West Lafayette with my three cats. I have soooo many books and I want to swap with you! (Especially if you have historical fiction books -- I LOVE those!!) My current favorites are Watership Down by Richard Adams and Half of a Yellow Sun by Chimamanda Ngoze Adichi! 🌿🐱🐝🌞",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ), // TODO: REPLACE WITH USER BIO
              ],
            ),
          ),

          // Community rating
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: Row(
              children: [
                Text(
                  "Community \nRating: ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                    'assets/community_rating.png'), // TODO: REPLACE WITH ACTUAL USER RATING IN FORM OF STARS
              ],
            ),
          ),

          // Library
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Library",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TODO: ADD LIBRARY
              ],
            ),
          ),
          //invite someone to the app
        ],
      ),
    );
  }
}
