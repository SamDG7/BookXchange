//import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
//import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

// A CONVERSION OF USER_PROFILE.DART FOR BOOK OBJECTS

// write functions here then import into screen 
Future<Book> createBook(String uuid, String title, String author, int year, List<String> genres, Image bookCover, String yourReview, bool currentStatus, int numSwaps) async {
  final response = await http.put(

    Uri.parse('http://10.0.0.127:8080/book/create_book'),

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
    return Book.fromJson(await jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      throw Exception('Failed to create book.');
  }
}

Future<Book> getCurrentBook(String uuid) async {

  final queryParameters = {
    'uuid': uuid
  };

  final response = await http

    .get(Uri.parse('http://10.0.0.127:8080/book/''$uuid'));

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
Future<Book> updateBook(String uuid, Image bookCover, String yourReview, bool currentStatus) async {
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
    }
    ),
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

class Book {

  final String uuid;
  final String title;
  final String author;
  final int year;
  final List<String> genres;
  final Image bookCover;
  final String yourReview;
  final bool currentStatus;
  final int numSwaps;

  const Book({required this.uuid, required this.title, required this. author, required this.year, required this.genres, required this.bookCover, required this.yourReview, required this.currentStatus, required this.numSwaps});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(

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

///// NOT SUPPOSED TO BE ABSTRACT -- JUST FOR NOW UNTIL I DEBUG
abstract class BookLibraryWidget extends StatefulWidget {
   BookLibraryWidget({super.key});

  Future<Book>? _currentBook = getCurrentBook(getUUID());

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0), 
        child: Column(
          children: <Widget>[


            // PUT FUTUREBUILDER FOR GETTING BOOK IMAGE HERE


            FutureBuilder<Book>(
              future: _currentBook,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // do something till waiting for data, we can show here a loader
                  return const CircularProgressIndicator();

                } else if (snapshot.hasData) {
                  final title = snapshot.data!.title;
                  return buildTitle(title);

                } else {
                  return const Text("No title available");
                  // we did not recieve any data, maybe show error or no data available
                }
              }
            ),

            FutureBuilder<Book>(
              future: _currentBook,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // do something till waiting for data, we can show here a loader
                  return const CircularProgressIndicator();

                } else if (snapshot.hasData) {
                  final author = snapshot.data!.author;
                  return buildAuthor(author);

                } else {
                  return const Text("No author available");
                  // we did not recieve any data, maybe show error or no data available
                }
              }
            ),



          ],
        ),
        ),
    );
  }

  // MAKE BUILDIMAGE WIDGET

  Widget buildTitle(String title) {
    return Text(title,
        style: TextStyle(
          fontSize: 15,
        ));
  }

  Widget buildAuthor(String author) {
    return Text(author,
        style: TextStyle(
          fontSize: 15,
        ));
  }
}