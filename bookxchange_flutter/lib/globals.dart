//global variables

import 'package:bookxchange_flutter/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

bool newUser = false;
var profileImage = getProfilePicture(getUUID());
String isbn13 = '';
String currentBookUID = '';
String modUserID = '';
List<dynamic> deletedUsers = [];
List<dynamic> chatEmails = [];

final List<String> genreList = [
      'Crime and Mystery',
      'Fantasy',
      'Historical',
      'Horror',
      'Romance',
      'Science Fiction',
      'Thriller',
      'Young-adult',
      'New-adult',
      'Biography',
      'Paranormal',
      'Classics',
      'Adventure',
      'Fairy Tale',
      'Mythology',
      'Fiction'
    ];

String getUUID() {
  //final User user = FirebaseAuth.instance.currentUser!;
  final uuid = FirebaseAuth.instance.currentUser!.uid;
  return uuid;
}

String getImageURL(String uuid) {
  return ('http://127.0.0.1:8080/user/get_picture/''$uuid');
  //return ('http://10.0.2.2:8080/user/get_picture/' '$uuid');
}

void modDeleteUser(String uuid) {
  deletedUsers.add(uuid);
  print(deletedUsers);
}

 Future<List<dynamic>> getDeletedUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/moderator/deleted_users'));
    
    if (response.statusCode == 200) {
        //final List body = json.decode(response.body);
        //deletedUsers = json.decode(response.body);
        //print(json.decode(response.body));
        //deletedUsers = json.decode(response.body);
        return json.decode(response.body);
        //return body.map((e) => ModUser.fromJson(e)).toList();
    } else {
      print("Error in getting deleted users");
      throw Exception('Failed to load deleted users');
    }
  }

   Future<List<dynamic>> getChatMatches(String user_uid) async {
    final response = await http.get(
    Uri.parse('http://127.0.0.1:8080/user/chat/$user_uid'));
    if (response.statusCode == 200) {

      //print(json.decode(response.body));
      chatEmails = json.decode(response.body);
      return chatEmails;
    } else {
      //print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
  }