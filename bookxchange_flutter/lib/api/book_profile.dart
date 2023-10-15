//import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
//import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';


// write functions here then import into screen 
Future<CreateBook> createBook(String uuid, String title, String author, int year, List<String> genres, Image bookCover, String yourReview, bool currentStatus, int numSwaps) async {
  final response = await http.put(

    Uri.parse('http://10.0.0.127:8080/user/create_profile'),

    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{

      'uuid': uuid,
      'title': title,
      'author': author,
      'year': year,
      'genres': genres,
      'book_cover': bookCover,
      'personal_review': yourReview,
      'status': currentStatus,
      'numberOfSwaps': numSwaps,

    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return CreateBook.fromJson(await jsonDecode(response.body));
    //return NewUser.fromJson(await json.decode(json.encode(response.body))); 
    //return NewUser.fromJson(json.decode(json.encode(response.body))); 
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      //debugPrint(jsonDecode(response.body));
      throw Exception('Failed to create book.');
  }
}

Future<UpdateBook> updateBook(String uuid, Image bookCover, String yourReview, bool currentStatus) async {
  final response = await http.put(

    Uri.parse('http://10.0.0.127:8080/user/update_profile'),
    
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{

      'uuid': uuid,
      'book_cover': bookCover,
      'personal_review': yourReview,
      'status': currentStatus,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return UpdateBook.fromJson(await jsonDecode(response.body));
    //return NewUser.fromJson(await json.decode(json.encode(response.body))); 
    //return NewUser.fromJson(json.decode(json.encode(response.body))); 
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      //debugPrint(jsonDecode(response.body));
      throw Exception('Failed to edit book.');
  }
}


// EDIT FOR SAVE BOOK COVER PIC
/* Future<http.StreamedResponse> saveProfilePicture(String uuid, File pickedImage) async {

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
} */




class CreateBook {
  final String uuid;
  final String title;
  final String author;
  final int year;
  final List<String> genres;
  final Image bookCover;
  final String yourReview;
  final bool currentStatus;
  final int numSwaps;

  const CreateBook({required this.uuid, required this.title, required this. author, required this.year, required this.genres, required this.bookCover, required this.yourReview, required this.currentStatus, required this.numSwaps});

  factory CreateBook.fromJson(Map<String, dynamic> json) {
    return CreateBook(
      uuid: json['uuid'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
      genres: json['genres'],
      bookCover: json['book_cover'],
      yourReview: json['personal_review'],
      currentStatus: json['status'],
      numSwaps: json['numberOfSwaps'],

    );
  }

}






class UpdateBook {
  final String uuid;
  final Image bookCover;
  final String yourReview;
  final bool currentStatus;

  const UpdateBook({required this.uuid, required this.bookCover, required this.yourReview, required this.currentStatus});

  factory UpdateBook.fromJson(Map<String, dynamic> json) {
    return UpdateBook(

      uuid: json['uuid'],
      bookCover: json['book_cover'],
      yourReview: json['personal_review'],
      currentStatus: json['status'],

    );
  }
}


