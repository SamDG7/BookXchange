//import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:http/http.dart' as http;
//import 'package:bookxchange_flutter/screens/edit_profile_page.dart';
import 'dart:convert';
import 'dart:async';

//createQueue

generateQueue() {}

Future<Queue> createQueue(String uuid) async {
  //actually creating the queue:
  //Get list of available books
  //Sort books by user intially set preferences

  final response = await http.put(
    Uri.parse('http://http://127.0.0.1:8080/queue/create_queue'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      // 'book_list': [],
    }),
  );

  if (response.statusCode == 201) {
    return Queue.fromJson(await jsonDecode(response.body));
  } else {
    throw Exception('Failed to Create queue');
  }
}

class Queue {
  final String uuid;
  // final List<Book> bookList;

  // const Queue({required this.uuid, required this.bookList});
  const Queue({required this.uuid});

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      uuid: json['uuid'],
      // bookList: json['book_list'],
    );
  }
}

//UpdateQueue
// Future<Queue> updateQueue(String uuid) async {}
// //getQueue
// Future<Queue> getQueue(String uuid) async {}
