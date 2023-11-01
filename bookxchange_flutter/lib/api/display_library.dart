import 'dart:convert';

import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


  Future<BookCovers> getBookCovers(String uuid) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8080/book/get_pictures/''$uuid'));
    if (response.statusCode == 200) {
      return BookCovers.fromJson(jsonDecode((response.body)));
    } else {
      throw Exception('Failed to load image');
    }
  }

  class BookCovers {
  final List<String> bookCover;

  const BookCovers({required this.bookCover});

  factory BookCovers.fromJson(Map<String, dynamic> json) {
    return BookCovers(
      bookCover: json['book_covers'],
    );
  }
}


