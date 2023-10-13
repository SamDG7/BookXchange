import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<ProfileAccount> fetchProfileAccount() async {
  final response = await http
      .get(Uri.parse('http://localhost:8080/user/fetch_profile'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ProfileAccount.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load profile account');
  }
}

class ProfileAccount {
  final String userName;
  final String userBio;
  //final Image userProfilePic;

  const ProfileAccount({
    required this.userName,
    required this.userBio,
    //required this.userProfilePic,
  });

  factory ProfileAccount.fromJson(Map<String, dynamic> json) {
    return ProfileAccount(
      userName: json['user_name'],
      userBio: json['user_bio'],
      //userProfilePic: json['user_profilepic'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<ProfileAccount> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = fetchProfileAccount();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<ProfileAccount>(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.userName);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}