import 'dart:convert';
import 'dart:ffi';

import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


List<ModUser> userList = [];
Future<List<ModUser>> getUserList() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/moderator/all_users'));
    
    if (response.statusCode == 200) {
        final List body = json.decode(response.body);
        return body.map((e) => ModUser.fromJson(e)).toList();
       
    } else {
      print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
  }

  Future<UserProfile> getUserModerator(String uuid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/moderator/get_user/''$uuid'));
    
    if (response.statusCode == 200) {

       //print(jsonDecode(response.body)[0]);

      return UserProfile.fromJson(jsonDecode(response.body)[0] as Map<String, dynamic>);
       
    } else {
      print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
  }

  Future<http.Response> moderatorDeleteUser(String userID) async {
      final http.Response response =
      await http.delete(
        Uri.parse('http://127.0.0.1:8080/moderator/delete_user/''$userID'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },

        // body: jsonEncode(<String, dynamic>{
        //   'uuid': userID,
        // }
        //),
      );
      return response;

    //   if (response.statusCode == 204) {
    //     return jsonDecode(response.body);
    //   } else {
    // //return response;
    //   throw Exception('Failed to delete user.');
  }

//}

  //List<ModUser> userList = [];
 


  class ModUser {
  final String uuid;
  final String userEmail;
  //final String userPhone;
  final String userName;
  //final String userBio;
  //final List userGenre;
  //final String userZipcode;
  //final String userRadius;

  const ModUser({required this.uuid, required this.userEmail, required this.userName});

  factory ModUser.fromJson(Map<String, dynamic> json) {
    return ModUser(
      uuid: json['uuid'] as String,
      userEmail: json['user_email'] as String,
     // userPhone: json['user_phone'] as String,
      userName: json['user_name'] as String,
 

    );
  }
}

 class UserProfile {
  final String uuid;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String userBio;
  final List userGenre;
  final String userZipcode;
  final String userRadius;
  final double userRating;
  final String userPicture;

  const UserProfile({required this.uuid, required this.userEmail, required this.userPhone, required this.userName, required this.userBio, required this.userGenre, required this.userZipcode, required this.userRadius, required this.userRating, required this.userPicture});
  //const UserProfile({required this.uuid, required this.userEmail, required this.userPhone, required this.userName, required this.userBio, required this.userZipcode, required this.userRadius, required this.userRating, required this.userPicture});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uuid: json['uuid'],
      userEmail: json['user_email'],
      userPhone: json['user_phone'],
      userName: json['user_name'],
      userBio: json['user_bio'],
      userGenre: json['user_genre'] as List,
      userZipcode: json['user_zipcode'],
      userRadius: json['user_radius'],
      userRating: json['user_rating'],
      userPicture: json['user_picture'],
    );
  }
}

