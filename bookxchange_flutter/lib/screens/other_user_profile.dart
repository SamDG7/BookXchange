import 'dart:convert';

import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/add_rating_page.dart';
import 'package:flutter/material.dart';

import '../api/other_profile.dart';

class OtherUser extends StatefulWidget {
  final String userId;

  const OtherUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  late Future<String?> userNameFuture;
  late Future<String?> aboutMeFuture;
  late Future<double?> userRatingFuture;
  late Future<String?> userPictureFuture;

  void changeData() {
    setState(() {
      userRatingFuture = getOtherUserCommunityRating(widget.userId);
    });
  }

  @override
  void initState() {
    super.initState();

    userNameFuture = getOtherUserName(widget.userId);
    aboutMeFuture = getOtherUserAboutMe(widget.userId);
    userRatingFuture = getOtherUserCommunityRating(widget.userId);
    userPictureFuture = getOtherUserImage(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: ListView(
        children: <Widget>[
          // NAME AND IMAGE
          Column(
            // CENTER NAME AND IMAGE
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              FutureBuilder<String?>(
                future: userNameFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final userNameData = snapshot.data;
                    return userNameData != null
                        ? Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userNameData,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        : Text('Name not available');
                  }
                },
              ),

              // add space between name and image
              const SizedBox(height: 10.0),

              CircleAvatar(
                radius: 75,
                //child: buildPicture(getImageURL(getUUID())),//Image.network(getImageURL(getUUID()), width: 70, height: 70)
                child: FutureBuilder<String?>(
                    // pass the list (postsFuture)
                    future: userPictureFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // do something till waiting for data, we can show here a loader
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        //final bio = snapshot.data!.userBio;
                        final userPicture = snapshot.data!;
                        return buildPicture(userPicture);
                        // Text(posts);
                        // we have the data, do stuff here
                      } else {
                        return const Text("No image available");
                        // we did not recieve any data, maybe show error or no data available
                      }
                    }),
              ),
            ],
          ),

          // ABOUT ME AND COMMUNITY RATING
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              // LEFT JUSTIFY ABOUT ME AND COMMUNITY RATING
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                FutureBuilder<String?>(
                  future: aboutMeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final aboutMeData = snapshot.data;
                      return aboutMeData != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About Me:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  aboutMeData,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: butterfly,
                                  ),
                                ),
                              ],
                            )
                          : Text('About Me not available');
                    }
                  },
                ),

                // add space between about me and community rating
                const SizedBox(height: 10.0),

                FutureBuilder<double?>(
                  future: userRatingFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final communityRating = snapshot.data;
                      return communityRating != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Community Rating:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  communityRating.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: butterfly,
                                  ),
                                ),
                              ],
                            )
                          : Text('Community Rating not available');
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 10.0),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddRatingScreen(userId: widget.userId),
                    ),
                  );

                  if (refresh == 'refresh') {
                    changeData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: butterfly,
                ),
                child: Text(
                  "Add User Rating",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPicture(String image64) {
    // ignore: unnecessary_null_comparison
    return userPictureFuture == null
        ? CircleAvatar(
            radius: 75,
            child: Text(
              'N',
              style: TextStyle(
                color: butterfly,
                fontWeight: FontWeight.w500,
                fontSize: 80,
              ),
            ))
        : CircleAvatar(
            radius: 75,
            backgroundImage: Image.memory(base64Decode(image64)).image);
  }
}
