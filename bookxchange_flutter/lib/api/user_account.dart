import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:convert';
import 'dart:async';



// CREATE NEW USER ACCOUNT 
Future<NewUser> createUser(String uuid, String email) async {
  final response = await http.post(
    //Uri.parse('http://localhost:8080/user/signup'),
    Uri.parse('http://192.168.4.74:8080/user/signup'),
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
    //return NewUser.fromJson(await json.decode(json.encode(response.body))); 
    //return NewUser.fromJson(json.decode(json.encode(response.body))); 
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      //debugPrint(jsonDecode(response.body));
      throw Exception('Failed to create user.');
  }
}

Future<ExistingUser> getUserLogin(String uuid) async {
  final queryParameters = {
    'uuid': uuid
  };
  final response = await http
  //.get(Uri.parse('http://localhost:8080/user/''$uuid'));
    .get(Uri.parse('http://192.168.4.74:8080/user/''$uuid'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ExistingUser.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user data');
  }
}

class NewUser {
  final String uuid;
  // String userEmail = '';
  // String userPhone = '';
  // String userName = '';
  // String userBio = '';

  //const NewUser({required this.uuid, this.userEmail, this.userPhone, this.userName, this.userBio});
  const NewUser({required this.uuid});

  factory NewUser.fromJson(Map<String, dynamic> json) {
    return NewUser(
      uuid: json['uuid'],
      // userEmail: json['user_email'],
      // userPhone: json['user_phone'],
      // userName: json['user_name'],
      // userBio: json['user_bio']
    );
  }
}

class ExistingUser {
  final String uuid;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String userBio;

  const ExistingUser({required this.uuid,required this.userEmail,required this.userPhone,required this.userName,required this.userBio});
  //const NewUser({required this.uuid});
  
  factory ExistingUser.fromJson(Map<String, dynamic> json) {
    return ExistingUser(
      uuid: json['uuid'],
      userEmail: json['user_email'],
      userPhone: json['user_phone'],
      userName: json['user_name'],
      userBio: json['user_bio']
    );
  }
}

// // GET
// void getUserData() async {
//   final response = await http.get('<https://localhost:8080/user/signup>');
//   if (response.statusCode == 200) {
//     print('User data: ${response.body}');
//   } else {
//     throw Exception('Failed to fetch user data');
//   }
// }




// Future<http.Response> createAlbum(String title) {
//   return http.post(
//     Uri.parse('https://localhost:8080/user/signup'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );
// }