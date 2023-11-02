import 'dart:math';
import 'dart:typed_data';

import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/api/display_library.dart';
import 'package:bookxchange_flutter/api/library_profile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/create_book_page.dart';

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
import 'package:bookxchange_flutter/api/display_library.dart';
import 'dart:convert';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<ExistingUser>? _existingUser = getUserLogin(getUUID());
  Future<ProfileImage>? _image = getProfilePicture(getUUID());
  //Future<BookCovers>? _bookCovers = getBookCovers(getUUID());
  Future<BookCovers>? _bookCovers = getBookCovers(getUUID());
  String baseUrl = 'https://127.0.0.1:8080/bookxchange_backend/book_covers';
  //Future<Image> _image = getProfilePicture(getUUID());
  // Future<Library>? _userLibrary = getCurrentLibrary(getUUID());

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
                )
            ),
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
                                   Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditLibraryScreen()),
                                // add screen to edit library here
                              ); 
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
                                        Text("Add a Book!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineLarge),
                                        SizedBox(height: 20),
                                        Text(
                                            "Add a book either manually or enter the ISBN to find your book!"),
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
                                                    color: Colors.white
                                                    ),
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
      //gridview will go here
      Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                
                child: Container(
                          child: FutureBuilder<BookCovers>(
                          future: _bookCovers,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                                final covers = snapshot.data!;
                                return buildBook(covers);
                            } else {
                              return const Text("There are no books in your library");
                            }
                          }),
                        
                  
                )
            ),


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
  Widget buildBook(BookCovers covers) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 2.0, // Spacing between columns
        mainAxisSpacing: 10.0, // Spacing between rows
      ),
      itemCount: covers.bookCover.length, // Number of items
      itemBuilder: (BuildContext context, int index) {
        return Image.memory(
          base64.decode(covers.bookCover[index]),
        );
      },

    );
  }

}
