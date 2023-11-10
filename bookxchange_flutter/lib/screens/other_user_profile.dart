import 'package:flutter/material.dart';

class OtherUser extends StatefulWidget {
  const OtherUser({Key? key}) : super(key: key);

  @override
  State<OtherUser> createState() => _OtherUserState();
}

class _OtherUserState extends State<OtherUser> {
  late Future<String> aboutMeFuture;
  late Future<String> bioFuture;
  late Future<double> communityRatingFuture;

  @override
  void initState() {
    super.initState();
    // Initialize your Future objects here
    aboutMeFuture = fetchAboutMe();
    bioFuture = fetchBio();
    communityRatingFuture = fetchCommunityRating();
  }

  Future<String> fetchAboutMe() async {
    // Simulate fetching about me data
    await Future.delayed(Duration(seconds: 2));
    return 'This is the about me section.';
  }

  Future<String> fetchBio() async {
    // Simulate fetching bio data
    await Future.delayed(Duration(seconds: 2));
    return 'This is the bio section.';
  }

  Future<double> fetchCommunityRating() async {
    // Simulate fetching community rating data
    await Future.delayed(Duration(seconds: 2));
    return 4.5; // Replace with the actual rating value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: aboutMeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text(
                    'About Me:\n${snapshot.data}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: bioFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bio:\n${snapshot.data}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<double>(
                        future: communityRatingFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              'Community Rating: ${snapshot.data}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
