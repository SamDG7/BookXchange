import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with menu navigation drawer and settings icon
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {}, // TODO: ADD ICON FUNCTIONALITY
            icon: const Icon(Icons.settings), // Settings icon
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: butterfly,
      ),
      drawer: Drawer(),

      // Vertical scrollable layout
      body: ListView(
        children: <Widget>[
          // Profile image, profile name, join date, edit profile button
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: OutlinedButton.icon(
                          onPressed: () {}, // TODO: ADD BUTTON FUNCTIONALITY
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
                    ],
                  ),
                ),
              ),
            ],
          ),

          // About me title and bio
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
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
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
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
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
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
        ],
      ),
    );
  }
}
