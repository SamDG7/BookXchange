import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

//import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:open_library/open_library.dart';

Future<Book> getCurrentBook(String bookIsbn) async {
  // final queryParameters = {
  //   'uuid': uuid
  // };

  final response = await http
      .get(Uri.parse('https://openlibrary.org/isbn/' '$bookIsbn' '.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(Book.fromJson(jsonDecode(response.body)));
    return Book.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load book data');
  }
}

class Book {
  //final String uuid;
  final String title;
  final String author;
  final String year;
  final List<String> genres;
  //final Image bookCover;
  final String isbn10;
  final String isbn13;
  final String identifiers;
  final String bookStatus;
  //final int numSwaps;

  const Book({required this.identifiers, required this.title, required this. author, required this.year, required this.genres, required this.isbn10, required this.isbn13, required this.bookStatus});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      //uuid: json['uuid'],
      
      title: json['title'],
      author: json['authors'],
      year: json['publish_date'],
      genres: json['genres'],
      isbn10: json['isbn_10'],
      isbn13: json['isbn_13'],
      bookStatus: json['book_status'],
      identifiers: json['identifiers']
      //bookCover: json['book_cover'],
      //yourReview: json['personal_review'],
      //currentStatus: json['status'],
      //numSwaps: json['numberOfSwaps'],
    );
  }
}
