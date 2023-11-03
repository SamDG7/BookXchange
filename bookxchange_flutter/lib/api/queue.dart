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


Future<NextBook> getNextBook(String uuid, String direction) async {
  //actually creating the queue:
  //Get list of available books
  //Sort books by user intially set preferences

  final response = await http.get(
    Uri.parse('http://127.0.0.1:8080/book/get_next/$uuid/$direction'));
    if (response.statusCode == 200) {
      // if (response.body.isEmpty) {
      //   return 
      // }
      var result = NextBook.fromJson(json.decode(response.body)[0]);
      return result;
    } else {
      //print("Error in getting book covers");
      throw Exception('Failed to load image');
    }
}

class NextBook {
  final String uuid;
  final String title;
  final String author;
  //final int year;
  final String isbn13;
  final String bookStatus;
  final List<dynamic> genres;
  final String bookCover;
  
  //final Image bookCover;
  //final String yourReview;
 // final bool currentStatus;
  //final int numSwaps;

  //const Book({required this.uuid, required this.title, required this. author, required this.year, required this.genres, required this.bookCover, required this.yourReview, required this.currentStatus, required this.numSwaps});
    const NextBook({required this.uuid, required this.title, required this.author, required this.isbn13, required this.genres, required this.bookStatus, required this.bookCover});
  factory NextBook.fromJson(Map<String, dynamic> json) {
    return NextBook(
      uuid: json['uuid'],
      title: json['title'],
      author: json['author'],
      //year: json['year'],
      isbn13: json['isbn13'],
      genres: json['genres'],
      bookStatus: json['book_status'],
      bookCover: json['book_cover'],
     // yourReview: json['personal_review'],
      //currentStatus: json['status'],
      //numSwaps: json['numberOfSwaps'],
      
    );
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
