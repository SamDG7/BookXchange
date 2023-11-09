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
  Future<SwipeRight>? swipe;
  late NextBook? _currentBook;
  //Future<NextBook>? _currentBook = _nextBook;
  bool right = false;
  //Future<SwipeRight>? _swipeRight = swipeRight(getUUID(), _nextBook![])
  //print(_nextBook.title)
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AppinioSwiper(
              cardsCount: 15,
              //onSwipe: 
              onSwiping: (AppinioSwiperDirection direction) async {
              //onSwiping: (AppinioSwiperDirection direction)  {
                print(direction.toString());
                if (direction == AppinioSwiperDirection.right) {
                  print("right");
                  right = true;
                  
                  _currentBook = await _nextBook;
                  swipe = swipeRight(getUUID(), _currentBook!.bookUid, _currentBook!.uuid);
                  print(_currentBook!.title);
                  print(_currentBook!.author);
                  _nextBook = getNextBook(getUUID(), "true");
                  //currentBook = _nextBook as NextBook;
                  //print(currentBook.title);
                } else {
                  right = false;
                  print("left");
                  _currentBook = await _nextBook;
                  _nextBook = getNextBook(getUUID(), "false");
                }
              },
              // swipeOptions: AppinioSwipeOptions.symmetric(
              //     horizontal: true, vertical: false),
              cardsBuilder: (BuildContext context, int index) {
                return Container(
                    alignment: Alignment.center,
                    //color: CupertinoColors.lightBackgroundGray,
                    color: Colors.transparent,
                    child: FutureBuilder<NextBook>(
                        // pass the list (postsFuture)
                        future: _nextBook,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // do something till waiting for data, we can show here a loader
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            //print(right);
                            //final bio = snapshot.data!.userBio;
                              final nextBook = snapshot.data!;
                            //print(nextBook.title);
                            //print(nextBook.author);
                              return buildNextBook(nextBook);
                            // Text(posts);
                            // we have the data, do stuff here
                          } else {
                            return const Text("Book Cover Image");
                            // we did not recieve any data, maybe show error or no data available
                          }
                        })
                    //child: const Text('Book Cover Image'), // You can replace this with an actual book cover image
                    );
              },
            ),
          ),
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
    // return GridView.builder(
    //   scrollDirection: Axis.vertical,
    //   shrinkWrap: true,
    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2, // Number of columns
    //     crossAxisSpacing: 2.0, // Spacing between columns
    //     mainAxisSpacing: 10.0, // Spacing between rows
    //   ),
    //   itemCount: covers.bookCover.length, // Number of items
    //   itemBuilder: (BuildContext context, int index) {
    return Card(
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
    //     },

    //   );
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