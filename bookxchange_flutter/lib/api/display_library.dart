import 'dart:convert';

import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

//
Future<BookCovers> getBookCovers(String uuid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/book/get_pictures/''$uuid'), headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      // if (response.body.isEmpty) {
      //   return 
      // }
      var result = BookCovers.fromJson(json.decode(response.body));
      return result;
    } else {
      //print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
  }

Future<List<LibraryBooks>> getSwappedBooks(String uuid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/user/matched_books/''$uuid'));
    if (response.statusCode == 200) {
      // if (response.body.isEmpty) {
      //   return 
      // }
      final List body = json.decode(response.body);
      return body.map((e) => LibraryBooks.fromJson(e)).toList();
    } else {
      //print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
  }

Future<List<LibraryBooks>> getLibraryBooks(String uuid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/library/''$uuid'));
    
    if (response.statusCode == 200) {
      // var result = BookCovers.fromJson(json.decode(response.body));
      // return result;
      final List body = json.decode(response.body);
      return body.map((e) => LibraryBooks.fromJson(e)).toList();
    } else {
      print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
  }


class BookCovers {
  final List<dynamic> bookCover;

  const BookCovers({required this.bookCover});

  factory BookCovers.fromJson(dynamic json) {
    return BookCovers(
      bookCover: json['book_covers'],
    );
  }
}

class LibraryBooks {
  final String bookUID;
  final String bookCover;

  const LibraryBooks({required this.bookUID, required this.bookCover});

  factory LibraryBooks.fromJson(Map<String, dynamic> json) {
    return LibraryBooks(
      bookUID: json['book_list'],
      bookCover: json['book_covers'],
    );
  }
}



