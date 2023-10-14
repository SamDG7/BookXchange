import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';


// write functions here then import into screen 
Future<CreateProfile> createUserProfile(String uuid, String userName, String userBio, List<String> userGenre, String userZipCode, Book userBook) async {
  final response = await http.put(

    Uri.parse('http://10.0.0.127:8080/user/create_profile'),

    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      'user_name': userName,
      'user_bio': userBio,
      'user_genre': userGenre,
      'user_zipcode': userZipCode,
      'user_book': userBook,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return CreateProfile.fromJson(await jsonDecode(response.body));
    //return NewUser.fromJson(await json.decode(json.encode(response.body))); 
    //return NewUser.fromJson(json.decode(json.encode(response.body))); 
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      //debugPrint(jsonDecode(response.body));
      throw Exception('Failed to create profile.');
  }
}

Future<UpdateProfile> updateUserProfile(String uuid, String userName, String userBio, Book userBook) async {
  final response = await http.put(

    Uri.parse('http://10.0.0.127:8080/user/update_profile'),
    
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      'user_name': userName,
      'user_bio': userBio,
      'user_book': userBook,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return UpdateProfile.fromJson(await jsonDecode(response.body));
    //return NewUser.fromJson(await json.decode(json.encode(response.body))); 
    //return NewUser.fromJson(json.decode(json.encode(response.body))); 
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      //debugPrint(jsonDecode(response.body));
      throw Exception('Failed to edit profile.');
  }
}

Future<http.StreamedResponse> saveProfilePicture(String uuid, File pickedImage) async {

  File imageFile = File(pickedImage.path);
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64.encode(imageBytes);
  
  final response = await http.put(

  Uri.parse('http://10.0.0.127/user/save_picture'),
  
  headers: <String, String>{
    'Content-Type': 'application/json',
  },
  body: jsonEncode(<String, dynamic>{
    'uuid': uuid,
    'picture': base64Image
  }),
);
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    //return CreateProfile.fromJson(await jsonDecode(response.body));
    return jsonDecode(response.body);
    //return NewUser.fromJson(await json.decode(json.encode(response.body))); 
    //return NewUser.fromJson(json.decode(json.encode(response.body))); 
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      //debugPrint(jsonDecode(response.body));
      throw Exception('Failed to save picture.');
  }
}

class CreateProfile {
  final String uuid;
  // String userEmail = '';
  // String userPhone = '';
  final String userName;
  final String userBio;
  final List<String> userGenre;
  final Book userBook;

  //const NewUser({required this.uuid, this.userEmail, this.userPhone, this.userName, this.userBio});
  const CreateProfile({required this.uuid, required this.userName, required this.userBio, required this.userGenre, required this.userBook});

  factory CreateProfile.fromJson(Map<String, dynamic> json) {
    return CreateProfile(
      uuid: json['uuid'],
      // userEmail: json['user_email'],
      // userPhone: json['user_phone'],
      userName: json['user_name'],
      userBio: json['user_bio'],
      userGenre: json['user_genre']
    );
  }
}

class UpdateProfile {
  final String uuid;
  // String userEmail = '';
  // String userPhone = '';
  final String userName;
  final String userBio;

  //const NewUser({required this.uuid, this.userEmail, this.userPhone, this.userName, this.userBio});
  const UpdateProfile({required this.uuid, required this.userName, required this.userBio});

  factory UpdateProfile.fromJson(Map<String, dynamic> json) {
    return UpdateProfile(
      uuid: json['uuid'],
      // userEmail: json['user_email'],
      // userPhone: json['user_phone'],
      userName: json['user_name'],
      userBio: json['user_bio'],
    );
  }
}
