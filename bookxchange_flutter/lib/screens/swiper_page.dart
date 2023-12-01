import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:bookxchange_flutter/api/queue.dart';
import 'package:bookxchange_flutter/globals.dart';

class BookSwiperScreen extends StatefulWidget {
  const BookSwiperScreen({Key? key});

  @override
  State<BookSwiperScreen> createState() => _BookSwiperScreenState();
}

class _BookSwiperScreenState extends State<BookSwiperScreen> {
  Future<NextBook>? _nextBook = getNextBook(getUUID(), "initial");
  Future<CheckMatch>? swipe;
  late NextBook? _currentBook;
  //Future<NextBook>? _currentBook = _nextBook;
  bool right = false;
  bool showMatchAnimation = false;
  //Future<SwipeRight>? _swipeRight = swipeRight(getUUID(), _nextBook![])
  //print(_nextBook.title)
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppinioSwiper(
                  cardsCount: 15,
                  onSwiping: (AppinioSwiperDirection direction) async {
                    print(direction.toString());
                    if (direction == AppinioSwiperDirection.right) {
                      print("right");
                      right = true;

                      _currentBook = await _nextBook;
                      swipe = swipeRight(
                          getUUID(), _currentBook!.bookUid, _currentBook!.uuid);
                      print(_currentBook!.title);
                      print(_currentBook!.author);
                      if (swipe == true) {
                        setState(() {
                          showMatchAnimation = true;
                        });
                        // Start a timer to hide the match animation after 3 seconds
                        Timer(Duration(seconds: 3), () {
                          setState(() {
                            showMatchAnimation = false;
                          });
                        });
                      }
                      _nextBook = getNextBook(getUUID(), "true");
                    } else {
                      right = false;
                      print("left");
                      _currentBook = await _nextBook;
                      _nextBook = getNextBook(getUUID(), "false");
                    }
                  },
                  cardsBuilder: (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: FutureBuilder<NextBook>(
                        future: _nextBook,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            final nextBook = snapshot.data!;
                            return buildNextBook(nextBook);
                          } else {
                            return const Text("Book Cover Image");
                          }
                        },
                      ),
                    );
                  },
                ),
                AnimatedOpacity(
                  opacity: showMatchAnimation ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: butterfly,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "It's a match!",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Uncomment the code below if you want to add thumbs up and thumbs down buttons
          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0),
                child: IconButton(
                  onPressed: () {       
                  },
                  icon: Icon(Icons.thumb_down_rounded,
                      size: 32, color: Colors.white),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0), 
                child: IconButton(
                  onPressed: () {
                  },
                  icon: Icon(Icons.thumb_up_rounded,
                      size: 32, color: Colors.white),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ),
            ],
          ),
          */
        ],
      ),
    );
  }

  Widget buildNextBook(NextBook book) {
    String book_author = book.author;

    return book.bookCover == null
    ? Card(
            child: Column(
            children: [
          SizedBox(height: 20,),
          Container(
            height: 450.0,
            child: const Text("Book Cover Image"),
          ),
          SizedBox(height: 10,),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Center(
                child: Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Center(
                child: Text(
                  "by $book_author",
                  style: TextStyle(
                    fontSize: 18, // Font size
                    color: Colors.black, // Text color
                  ),
                ),
              ),
            ),
          ),
          
          
        ],))
        : Card(
      elevation: 4.0,
      //color: butterfly_light,
      //color: Colors.grey[100],
      child: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            height: 450.0,
            child: Image.memory(base64.decode(book.bookCover)),
          ),
          SizedBox(height: 10,),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Center(
                child: Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
              child: Center(
                child: Text(
                  "by $book_author",
                  style: TextStyle(
                    fontSize: 18, // Font size
                    color: Colors.black, // Text color
                  ),
                ),
              ),
            ),
          ),
          
          
        ],
      ),
    );

    // return Card(
    //   elevation: 4.0,

    //   child: Column(
    //     children: [
    //       SizedBox(
    //         height: 20,
    //       ),
    //       Container(
    //         height: 450.0,
    //         child: Image.memory(base64.decode(book.bookCover)),
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       ListTile(
    //         title: Padding(
    //           padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
    //           child: Center(
    //             child: Text(
    //               book.title,
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.black,
    //               ),
    //             ),
    //           ),
    //         ),
    //         subtitle: Padding(
    //           padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
    //           child: Center(
    //             child: Text(
    //               "by $book_author",
    //               style: TextStyle(
    //                 fontSize: 18, // Font size
    //                 color: Colors.black, // Text color
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

  }
}


 //THIS IS THE CODE THAT GIVES THE FRONTEND ERRORS
/*
@override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: AppinioSwiper(
          cardsCount: queue?.bookCovers.length ?? 0,
          onSwiping: (AppinioSwiperDirection direction) {
            print(direction.toString());
          },
          cardsBuilder: (BuildContext context, int index) {
            if (queue == null || index >= queue!.bookCovers.length) {
              return Container(); // Placeholder or loading indicator
            } else {
              return Image.network(
                queue!.bookCovers[index],
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              );
            }
          },
        ),
      ),
    );
  } */