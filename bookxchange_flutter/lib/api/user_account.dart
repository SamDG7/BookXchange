import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

// CREATE NEW USER ACCOUNT
Future<NewUser> createUser(String uuid, String email) async {
  final response = await http.put(
    //Uri.parse('http://localhost:8080/user/signup'),
    Uri.parse('http://127.0.0.1:8080/user/signup'),
    //Uri.parse('http://10.0.2.2:8080/user/signup'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'uuid': uuid,
      'user_email': email,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return NewUser.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //debugPrint(jsonDecode(response.body));
    throw Exception('Failed to create user.');
  }
}

Future<ExistingUser> getUserLogin(String uuid) async {
  final queryParameters = {'uuid': uuid};
  final response = await http
      //.get(Uri.parse('http://localhost:8080/user/''$uuid'));
       .get(Uri.parse('http://127.0.0.1:8080/user/''$uuid'));
      //.get(Uri.parse('http://10.0.2.2:8080/user/' '$uuid'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(ExistingUser.fromJson(
    //     jsonDecode(response.body)[0] as Map<String, dynamic>));
    
    return ExistingUser.fromJson(
        jsonDecode(response.body)[0] as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user data');
  }
}

class NewUser {
  final String uuid;

  const NewUser({required this.uuid});

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      uuid: json['uuid'],
    );
  }
}

class ExistingUser {
  final String uuid;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String userBio;
  final String userZipCode;
  final String userRadius;
  final double userRating;
  final int numRaters;
  final List<dynamic> cities;


  const ExistingUser(
      {required this.uuid,
      required this.userEmail,
      required this.userPhone,
      required this.userName,
      required this.userBio,
      required this.userZipCode,
      required this.userRadius,
      required this.userRating,
      required this.numRaters,
      required this.cities});
  //const NewUser({required this.uuid});

  factory ExistingUser.fromJson(Map<String, dynamic> json) {
    return ExistingUser(
        uuid: json['uuid'],
        userEmail: json['user_email'],
        userPhone: json['user_phone'],
        userName: json['user_name'],
        userBio: json['user_bio'],
        userZipCode: json['user_zipcode'],
        userRadius: json['user_radius'],
        userRating: json['user_rating'],
        numRaters: json['num_raters'],
        cities: json['cities']);
  }
}
