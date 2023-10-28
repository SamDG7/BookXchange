import 'dart:math';
import 'dart:typed_data';

import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/create_book_page.dart';
import 'package:bookxchange_flutter/screens/create_book_isbn_page.dart';
import 'package:bookxchange_flutter/screens/display_book_isbn_page.dart';
import 'package:bookxchange_flutter/screens/book_page.dart';
import 'package:bookxchange_flutter/screens/edit_book_page.dart';
import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:bookxchange_flutter/api/user_account.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:convert';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<ExistingUser>? _existingUser = getUserLogin(getUUID());
  Future<ProfileImage>? _image = getProfilePicture(getUUID());
  
  //Future<Image> _image = getProfilePicture(getUUID());

  Future<void> shareApp() async {
    // Set the app link and the message to be shared
    const String appLink = 'https://github.com/SamDG7/BookXchange';
    const String message =
        'Hey! I just joined this really cool app called BookXchange! Become a member of our book-lover community and read your favorite books!';

    // Share the app link and message using the share dialog
    await FlutterShare.share(
        title: 'Share App', text: message, linkUrl: appLink);
  }

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
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                
                child: Container(
                  //children: [
                  child: CircleAvatar(
                  radius: 75,
                    //child: buildPicture(getImageURL(getUUID())),//Image.network(getImageURL(getUUID()), width: 70, height: 70)
                    child: FutureBuilder<ProfileImage>(
                        // pass the list (postsFuture)
                        future: _image,
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
                  // width: 150,
                  // height: 150,
                  //fit: BoxFit.cover)
                )
                
                    //child: FutureBuilder<Image>(
                          // pass the list (postsFuture)
                          //future: _image,
                          //builder: (context, snapshot) {
                            //if (snapshot.connectionState ==
                                //ConnectionState.waiting) {
                              // do something till waiting for data, we can show here a loader
                              //return const CircularProgressIndicator();
                            //} else if (snapshot.hasData) {
                              //final name = snapshot.data!.user_picture;
                              //]
                    
                   // )
                              // Text(posts);
                              // we have the data, do stuff here
                            //} else {
                              //return const Text("N");
                              // we did not recieve any data, maybe show error or no data available
                            //}
            ),
            
                    
                  //backgroundColor: butterfly,
                  // child: getProfilePicture(getUUID())  == null
                  //   //? Image.file(File('assets/profile_pic_elena.png'))
                  //   ? Text('N',
                  //     style: TextStyle(
                  //       color: butterfly,
                  //       fontWeight: FontWeight.w500,
                  //       fontSize: 80,
                  //     ),
                  //   )
                  //   child: Image.memory(base64Decode(await getProfilePicture(getUUID())),
                  //   width: 150,
                  //   height: 150,
                  //   fit: BoxFit.cover),
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
                  
              //),
              
              // Padding(
              //   padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              //   child: Container(
              //     child: getProfilePicture(getUUID())
              //     // child: FutureBuilder<Image>(
              //     //         // pass the list (postsFuture)
              //     //         future: Image,
              //     //         builder: (context, snapshot) {
              //     //           if (snapshot.connectionState ==
              //     //               ConnectionState.waiting) {
              //     //             // do something till waiting for data, we can show here a loader
              //     //             return const CircularProgressIndicator();
              //     //           } else if (snapshot.hasData) {
              //     //             //final name = snapshot.data!.userName;
              //     //             return Image;
              //     //             // Text(posts);
              //     //             // we have the data, do stuff here
              //     //           } else {
              //     //             return const Text("No name available");
              //     //             // we did not recieve any data, maybe show error or no data available
              //     //           }
              //     //         }),


              //     // child: CircleAvatar(
              //     //   radius: 80,
              //     //   backgroundColor: butterfly,
              //     //   child: CircleAvatar(
              //     //     radius: 75,
              //     //     backgroundImage:
              //     //         AssetImage('assets/profile_pic_elena.png'),
              //     //   ),
              //     // ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: Container(
                  child: Column(
                    children: [
                      FutureBuilder<ExistingUser>(
                          // pass the list (postsFuture)
                          future: _existingUser,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // do something till waiting for data, we can show here a loader
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              final name = snapshot.data!.userName;
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

                      //Edit profile option
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                        Text("Love This App? Share The Love!",
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
                                                    .all<Size>(Size(150, 50)),
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
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(butterfly),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(Size(150, 50)),
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
                    child: FutureBuilder<ExistingUser>(
                        // pass the list (postsFuture)
                        future: _existingUser,
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
                //       Padding(
                //         padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                //         child: Text(
                //           "Hello! My name is Elena and I live in West Lafayette with my three cats. I have soooo many books and I want to swap with you! (Especially if you have historical fiction books -- I LOVE those!!) My current favorites are Watership Down by Richard Adams and Half of a Yellow Sun by Chimamanda Ngoze Adichi! 🌿🐱🐝🌞",
                //           style: TextStyle(
                //             fontSize: 15,
                //           ),
                //         ),
                //       ), // TODO: REPLACE WITH USER BIO
                //     ],
                //   ),
                // ),

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
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Library",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child:

                              // Title and edit button
                              Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookAboutScreen()),
                                // add screen to edit library here
                              ); */
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: butterfly,
                                ),
                                label: Text(
                                  'Edit Library',
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side:
                                      BorderSide(width: 1.0, color: butterfly),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Add book button
                              OutlinedButton.icon(
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
                                        Text("Add book manually",
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
                                                Navigator.push(
                                                  context,
                                                    MaterialPageRoute(
                                                    builder: (context) =>
                                                    AddBooktoLibraryScreen()),
                                    // add screen to edit library here
                                                  );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(butterfly),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(Size(150, 50)),
                                              ),
                                              child: Text(
                                                "Add book manually",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                    MaterialPageRoute(
                                                    builder: (context) =>
                                                    //AddBookISBNScreen()),
                                                    DisplayBookISBNScreen()),
                                    // add screen to edit library here
                                                  );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(butterfly),
                                                fixedSize: MaterialStateProperty
                                                    .all<Size>(Size(150, 50)),
                                              ),
                                              child: Text(
                                                "Add book via ISBN",
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
                                  Icons.add,
                                  color: butterfly,
                                ),
                                label: Text(
                                  'Add Book',
                                  style: TextStyle(color: Colors.grey[800]),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side:
                                      BorderSide(width: 1.0, color: butterfly),
                                ),
                              ),
                            ],
                          ),
                          ),
                      // TODO: ADD LIBRARY
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

}
