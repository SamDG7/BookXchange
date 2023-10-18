import 'package:bookxchange_flutter/api/book_profile.dart';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

Future<Library> getCurrentLibrary(String uuid) async {

  final queryParameters = {
    'uuid': uuid
  };

  final response = await http

    .get(Uri.parse('http://10.0.0.127:8080/library/''$uuid'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Library.fromJson(jsonDecode(response.body)[0] as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load book data');
  }
}

class Library {
  
  final String uuid;
  final List<Book> bookList;
  
  const Library({required this.uuid, required this.bookList});

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(

      uuid: json['uuid'],
      bookList: json['book_list'],
     
    );
  }
}