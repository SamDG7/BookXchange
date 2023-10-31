import 'dart:typed_data';

import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

// write functions here then import into screen
Future<CreateProfile> createUserProfile(String uuid, String userName,
    String userBio, List<String> userGenre, String userZipCode) async {
  final response = await http.put(
    //Uri.parse('http://localhost:8080/user/create_profile'),
    // Uri.parse('http://127.0.0.1:8080/user/create_profile'),
    Uri.parse('http://10.0.2.2:8080/user/create_profile'),
    //http://192.168.4.74:8080
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      'user_name': userName,
      'user_bio': userBio,
      'user_genre': userGenre,
      'user_zipcode': userZipCode,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return CreateProfile.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //debugPrint(jsonDecode(response.body));
    throw Exception('Failed to create profile.');
  }
}

Future<UpdateProfile> updateUserProfile(
    String uuid, String userName, String userBio, String userZipCode) async {
  final response = await http.put(
    //Uri.parse('http://localhost:8080/user/update_profile'),
    //Uri.parse('http://127.0.0.1:8080/user/update_profile'),
    Uri.parse('http://10.0.2.2:8080/user/update_profile'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      'user_name': userName,
      'user_bio': userBio,
      'user_zipcode': userZipCode,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return UpdateProfile.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    //debugPrint(jsonDecode(response.body));
    throw Exception('Failed to edit profile.');
  }
}

Future<Map<String, dynamic>> saveProfilePicture(
    String uuid, File pickedImage) async {
  // var request =
  //     http.MultipartRequest('POST', Uri.parse('http://192.168.4.74:8080/user/save_picture'));
  // request.fields['uuid'] = uuid;
  // request.files.add(http.MultipartFile.fromBytes('picture', File(pickedImage.path).readAsBytesSync(),filename: pickedImage.path));
  //   //http://192.168.4.74:8080
  //   var response = await request.send();
  File imageFile = File(pickedImage.path);
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64.encode(imageBytes);
  final response = await http.post(
    //Uri.parse('http://localhost:8080/user/update_profile'),
    // Uri.parse('http://127.0.0.1:8080/user/save_picture'),
    Uri.parse('http://10.0.2.2:8080/user/save_picture'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{'uuid': uuid, 'picture': base64Image}),
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

Future<ProfileImage> getProfilePicture(String uuid) async {
  http.Response response = await http
      //.get(Uri.parse('http://localhost:8080/user/''$uuid'));
      .get(Uri.parse(getImageURL(uuid)));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ProfileImage.fromJson(jsonDecode((response.body)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load user data');
  }
}

class CreateProfile {
  final String uuid;
  final String userName;
  final String userBio;
  final List<String> userGenre;
  final String userZipCode;

  const CreateProfile(
      {required this.uuid,
      required this.userName,
      required this.userBio,
      required this.userGenre,
      required this.userZipCode});
  //const CreateProfile({required this.uuid, required this.userName, required this.userBio, required this.userGenre});

  factory CreateProfile.fromJson(Map<String, dynamic> json) {
    return CreateProfile(
        uuid: json['uuid'],
        userName: json['user_name'],
        userBio: json['user_bio'],
        userGenre: json['user_genre'],
        userZipCode: json['user_zipcode']);
  }
}

class UpdateProfile {
  final String uuid;
  final String userName;
  final String userBio;
  final String userZipCode;

  const UpdateProfile(
      {required this.uuid,
      required this.userName,
      required this.userBio,
      required this.userZipCode});

  factory UpdateProfile.fromJson(Map<String, dynamic> json) {
    return UpdateProfile(
        uuid: json['uuid'],
        userName: json['user_name'],
        userBio: json['user_bio'],
        userZipCode: json['user_zipcode']);
  }
}

class ProfileImage {
  final String userPicture;

  const ProfileImage({required this.userPicture});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      userPicture: json['user_picture'],
    );
  }
}

//checks if zipcode is valid
Future<List<dynamic>> fetchData(userZipCode) async {
  final response = await http.get(
     Uri.parse('https://zipcodedownload.com/ZipList?zipList=''$userZipCode''&state=&country=us5&format=json&pagenumber=1&key=682e852e2e054212b39d494d29ad3a47')
  );
  if (response.statusCode == 200) {
    print(json.decode(response.body));
    return json.decode(response.body);
  } else {
    print(response.statusCode);
    throw Exception('Failed to fetch data');
  }
}
