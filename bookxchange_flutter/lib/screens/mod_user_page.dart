import 'dart:math';
import 'dart:typed_data';

import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/api/display_library.dart';
import 'package:bookxchange_flutter/api/library_profile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/create_book_page.dart';
import 'package:bookxchange_flutter/screens/mod_page.dart';
import 'package:bookxchange_flutter/screens/display_book_isbn_page.dart';
import 'package:bookxchange_flutter/screens/book_page.dart';
import 'package:bookxchange_flutter/screens/edit_book_page.dart';
import 'package:bookxchange_flutter/screens/edit_library_page.dart';
import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:bookxchange_flutter/api/user_account.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:bookxchange_flutter/api/moderator_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:convert';



enum MenuItem { item1 }

class ModUserScreen extends StatefulWidget {
  const ModUserScreen({super.key});

  @override
  State<ModUserScreen> createState() => _ModUserScreenState();
}

class _ModUserScreenState extends State<ModUserScreen> {
  Future<UserProfile>? _moderatorUserProfile = getUserModerator(modUserID);
  

  final user = FirebaseAuth.instance.currentUser!;
  //late String _msg = "";
  //late String _subject = "";
  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //final FirebaseUser user = await auth.currentUser();
  //final userid = user.uid;
  //function to sign the user out
  void signUserOut() async {
    print("Signing user out");
    //final googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    //await googleSignIn.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }
  
   void successllyDeletedUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deleted User'),
          content: Text('You have successfully deleted this user!',
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ModHomePage()),);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deleteUserConfirmationPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Deletion of User",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to delete this user?", style: TextStyle(fontSize: 16)),
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
                successllyDeletedUser(context);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // Vertical scrollable layout
      appBar: AppBar(
     
        backgroundColor: butterfly,

        title: FutureBuilder(
        future: _moderatorUserProfile,
        builder: (context, snapshot){
         return Text(snapshot.hasData
           ? snapshot.data!.userName
          : "User Info", 
          style: TextStyle(color: Colors.white,
             fontWeight: FontWeight.bold
             )
          );//AppLocalizations.of(context)!.loading
        }
      ),
      ),
      body: ListView(
        children: <Widget>[
          // Profile image, profile name, join date, edit profile button, share profile
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                
                child: Container(
                  //children: [
                  child: CircleAvatar(
                  radius: 75,
                  
                    //child: buildPicture(getImageURL(getUUID())),//Image.network(getImageURL(getUUID()), width: 70, height: 70)
                    child: FutureBuilder<UserProfile>(
                        // pass the list (postsFuture)
                        future: _moderatorUserProfile,
                        
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // do something till waiting for data, we can show here a loader
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            //final bio = snapshot.data!.userBio;
                            final userPicture = snapshot.data!.userPicture;
                            
                            return buildPicture(userPicture);
                            // Text(posts);
                            // we have the data, do stuff here
                          } else {
                            return const Text("No image available");
                            // we did not recieve any data, maybe show error or no data available
                          }
                        })
                  ),
                )
            ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: Container(
                  child: Column(
                    children: [
                      FutureBuilder<UserProfile>(
                          // pass the list (postsFuture)
                          future: _moderatorUserProfile,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // do something till waiting for data, we can show here a loader
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              final name = snapshot.data!.userName;
                              print(name);
                              return buildName(name);
                              // Text(posts);
                              // we have the data, do stuff here
                            } else {
                              return const Text("No name available");
                              // we did not recieve any data, maybe show error or no data available
                            }
                          }),
                      // Text(
                      //   "Elena Monroe", // TODO: REPLACE WITH USER IMAGE
                      //   textAlign: TextAlign.left,
                      //   style: TextStyle(
                      //     fontSize: 25,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                          "Joined Oct. 1st, 2023"), // TODO: REPLACE WITH USER JOIN DATE
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
                FutureBuilder<UserProfile>(
                future: _moderatorUserProfile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final radius = snapshot.data!.userRadius;
                    return buildRadius(radius);
                  } else {
                    return Text("No radius available");
                  }
                },
              ),
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
                    child: FutureBuilder<UserProfile>(
                        // pass the list (postsFuture)
                        future: _moderatorUserProfile,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // do something till waiting for data, we can show here a loader
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            final bio = snapshot.data!.userBio;
                            return buildBio(bio);
                            // Text(posts);
                            // we have the data, do stuff here
                          } else {
                            return const Text("No bio available");
                            // we did not recieve any data, maybe show error or no data available
                          }
                        })),
                
                // Community rating
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  padding: EdgeInsets.fromLTRB(100, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          modDeleteUser(modUserID);
                          moderatorDeleteUser(modUserID);
                          deleteUserConfirmationPopUp(context);
                         //Navigator.pop(context);
                            // Navigator.push(
                            // context,
                            // MaterialPageRoute(
                            //     builder: (context) => ModHomePage()),);
                          
                        },
                              //   onPressed: () {
                                  
                              //   //    Navigator.push(
                              //   // context,
                              //   // MaterialPageRoute(
                              //   //     builder: (context) => EditLibraryScreen()),
                              //   // add screen to edit library here
                              // ); 
                                //},
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: butterfly,
                                ),
                                label: Text(
                                  'Delete User',
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side:
                                      BorderSide(width: 1.0, color: butterfly),
                                ),
                              ),
      //gridview will go here
                    ],
                  ),
                ),
                //invite someone to the app
              ],
            ),
          )
        ],
      ),
      
    );
  }
  

  Widget buildBio(String userbio) {
    return Text(userbio,
        style: TextStyle(
          fontSize: 15,
        ));
  }

  Widget buildName(String username) {
    return  Text(
      username,
      textAlign: TextAlign.left,
      softWrap: true,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.clip,
      ),
    );
  //}
  //);
  }

  Widget buildPicture(String image64) {
    // ignore: unnecessary_null_comparison
    return  profileImage == null ? CircleAvatar(radius: 75, child: Text('N',
                      style: TextStyle(
                        color: butterfly,
                        fontWeight: FontWeight.w500,
                        fontSize: 80,
                      ),
                    )) : CircleAvatar(radius: 75, backgroundImage: Image.memory(base64Decode(image64)).image);

  }
  //should buildgrid

  
  Widget buildRadius(String userRadius) {
  return Row(
    children: [
      Text(
        "My Radius: ",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        userRadius,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      Text(
        " miles",
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    ],
  );
}


}
