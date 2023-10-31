//import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

//import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

// A CONVERSION OF USER_PROFILE.DART FOR BOOK OBJECTS

// write functions here then import into screen 
//Future<Book> createBook(String uuid, String title, String author, int year, List<String> genres, Image bookCover, String yourReview, bool currentStatus, int numSwaps) async {
Future<Book> createBook(String uuid, String title, String author, String isbn13, List<String> genres, File pickedImage) async {
  File imageFile = File(pickedImage.path);
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64.encode(imageBytes);
  final response = await http.post(
    //Uri.parse('http://10.0.2.2:8080/book/create_book'),
    //Uri.parse('http://10.0.0.127:8080/book/create_book'),
    Uri.parse('http://127.0.0.1:8080/book/create_book'),

    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      'title': title,
      'author': author,
      //'year': year,
      'isbn13': isbn13,
      'genres': genres,
      'book_cover': base64Image
      
      // 'book_cover': base64Image,
      //'personal_review': yourReview,
      //'status': currentStatus,
      //'numberOfSwaps': numSwaps,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Book.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      throw Exception('Failed to create book.');
  }
}

Future<Book> createBookISBN(String uuid, String title, String author, String isbn13, List<String> genres, Uint8List pickedImage) async {
  String base64Image = base64.encode(pickedImage);
  final response = await http.post(

    //Uri.parse('http://10.0.0.127:8080/book/create_book'),
    Uri.parse('http://127.0.0.1:8080/book/create_book'),

    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{

      'uuid': uuid,
      'title': title,
      'author': author,
      //'year': year,
      'isbn13': isbn13,
      'genres': genres,
      'book_cover': base64Image
      
      // 'book_cover': base64Image,
      //'personal_review': yourReview,
      //'status': currentStatus,
      //'numberOfSwaps': numSwaps,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Book.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create book.');
  }
}

Future<Book> getCurrentBook(String uuid) async {
  final queryParameters = {'uuid': uuid};

  // final response =
  //     await http.get(Uri.parse('http://10.0.0.127:8080/book/' '$uuid'));
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8080/book/' '$uuid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Book.fromJson(jsonDecode(response.body)[0] as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load book data');
  }
}

// TODO: BUT MANY BOOKS WILL HAVE THE SAME UUID???

// edit a Book with the corresponding uuid
Future<Book> updateBook(
    String uuid, Image bookCover, String yourReview, bool currentStatus) async {
  final response = await http.put(
    // Route declared in the backend (bookxchange_backend/app.py)
    Uri.parse('http://10.0.0.127:8080/book/update_book'),

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
    return Book.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to edit book.');
  }
}


Future<Map<String,dynamic>> saveBookCoverPicture(String uuid, File pickedImage) async {
  File imageFile = File(pickedImage.path);
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64.encode(imageBytes);
  final response = await http.post(
  Uri.parse('http://127.0.0.1:8080/book/save_picture'),
  headers: <String, String>{
    'Content-Type': 'application/json',
  },
  body: jsonEncode(<String, dynamic>{
    'uuid': uuid,
    'book_cover': base64Image
  }),
);
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to save picture.');
  }
}

Future<BookCoverImage> getBookCoverPicture(String uuid) async {
  http.Response response = await http.get(Uri.parse(getImageURL(uuid)));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return BookCoverImage.fromJson(jsonDecode((response.body)));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load book cover');
  }
}

class Book {
  final String uuid;
  final String title;
  final String author;
  //final int year;
  final String isbn13;
  final List<String> genres;
  
  //final Image bookCover;
  //final String yourReview;
 // final bool currentStatus;
  //final int numSwaps;

  //const Book({required this.uuid, required this.title, required this. author, required this.year, required this.genres, required this.bookCover, required this.yourReview, required this.currentStatus, required this.numSwaps});
    const Book({required this.uuid, required this.title, required this.author, required this.isbn13, required this.genres});
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      uuid: json['uuid'],
      title: json['title'],
      author: json['author'],
      //year: json['year'],
      isbn13: json['isbn13'],
      genres: json['genres'],
      //bookCover: json['book_cover'],
     // yourReview: json['personal_review'],
      //currentStatus: json['status'],
      //numSwaps: json['numberOfSwaps'],
      
    );
  }
}

class BookCoverImage {
  final String userPicture;

  const BookCoverImage({required this.userPicture});

  factory BookCoverImage.fromJson(Map<String, dynamic> json) {
    return BookCoverImage(
      userPicture: json['user_picture'],
    );
  }
}
