//import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    Uri.parse('http://127.0.0.1:8080/queue/create_queue'),
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

Future<CheckMatch> swipeRight(String uuid, String bookUID, String bookUserID) async {

  final response = await http.put(
    Uri.parse('http://127.0.0.1:8080/book/check_match'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'uuid': uuid,
      'book_uid': bookUID,
      'book_user_id': bookUserID
    }),
  );

  if (response.statusCode == 201) {
    //return SwipeRight.fromJson(await jsonDecode(response.body));
    //return await jsonDecode(response.body);
    return CheckMatch.fromJson(await jsonDecode(response.body));
  } else {
    throw Exception('Failed to add to right list');
  }
}


class NextBook {
  final String uuid;
  final String bookUid;
  final String title;
  final String author;
  //final int year;
  final String isbn13;
  final String bookStatus;
  final List<dynamic> genres;
  final dynamic bookCover;

  //const Book({required this.uuid, required this.title, required this. author, required this.year, required this.genres, required this.bookCover, required this.yourReview, required this.currentStatus, required this.numSwaps});
    const NextBook({required this.uuid, required this.bookUid, required this.title, required this.author, required this.isbn13, required this.genres, required this.bookStatus, required this.bookCover});
  factory NextBook.fromJson(Map<String, dynamic> json) {
    return NextBook(
      uuid: json['uuid'],
      bookUid: json['_id'],
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

class SwipeRight {
  final String uuid;
  final String bookUID;
  final String bookUserID;
  // final List<Book> bookList;

  // const Queue({required this.uuid, required this.bookList});
  const SwipeRight({required this.uuid, required this.bookUID, required this.bookUserID});

  factory SwipeRight.fromJson(Map<String, dynamic> json) {
    return SwipeRight(
      uuid: json['uuid'],
      bookUID: json['book_uid'],
      bookUserID: json['book_user_id'],
      // bookList: json['book_list'],
    );
  }
}

class CheckMatch {
  final String match;

  const CheckMatch({required this.match});

  factory CheckMatch.fromJson(Map<String, dynamic> json) {
    return CheckMatch(
      match: json['match'],
      // bookList: json['book_list'],
    );
  }
}

class ChatEmails {
  final List email;

  const ChatEmails({required this.email});

  factory ChatEmails.fromJson(Map<String, dynamic> json) {
    return ChatEmails(
      email: json['match_emails'],
      // bookList: json['book_list'],
    );
  }
}

//UpdateQueue
// Future<Queue> updateQueue(String uuid) async {}
// //getQueue
// Future<Queue> getQueue(String uuid) async {}
