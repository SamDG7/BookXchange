import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/add_rating_page.dart';
import 'package:flutter/material.dart';

import '../api/other_profile.dart';

enum OtherMenuItem { item1, item2 }

class OtherUser extends StatefulWidget {
  final String userId;

  const OtherUser({Key? key, required this.userId}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  late Future<String?> aboutMeFuture;
  late Future<String?> bioFuture;
  late Future<double?> userRatingFuture;
  bool value = false;

  void changeData() {
    setState(() {
      userRatingFuture = getOtherUserCommunityRating(widget.userId);
    });
  }

  

  @override
  void initState() {
    super.initState();
    // Initialize your Future objects here
    aboutMeFuture = getOtherUserAboutMe(widget.userId);
    bioFuture = getOtherUserBio(widget.userId);
    userRatingFuture = getOtherUserCommunityRating(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                      ? Text(
                          'About Me:\n$aboutMeData',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text('About Me not available');
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<String?>(
              future: bioFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final bioData = snapshot.data;
                  return bioData != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bio:\n$bioData',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            value
                                ? FutureBuilder<double?>(
                                    future: userRatingFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final communityRating = snapshot.data;
                                        return communityRating != null
                                            ? Text(
                                                'Community Rating: ${communityRating.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                'Community Rating not available');
                                      }
                                    },
                                  )
                                : FutureBuilder<double?>(
                                    future: userRatingFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final communityRating = snapshot.data;
                                        return communityRating != null
                                            ? Text(
                                                'Community Rating: ${communityRating.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                'Community Rating not available');
                                      }
                                    },
                                  ),
                          ],
                        )
                      : Text('Bio not available');
                }
              },
            ),
            const SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.fromLTRB(87, 0, 0, 20),
              child: ElevatedButton(
                //GET RID OF???
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
            ),
            /*
            Padding(
              padding: EdgeInsets.fromLTRB(110, 0, 0, 150),
              child: ElevatedButton(
                //GET RID OF???
                onPressed: () {
                  blockUserConfirmationPopup(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: butterfly,
                ),
                child: Text(
                  "Block User",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}
