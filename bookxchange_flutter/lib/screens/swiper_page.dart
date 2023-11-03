import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        //leading: Image.asset('assets/logo_no_text.png'), //looks kinda ugly
        middle: Text(
          'Happy Swiping!',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold, // Set text to bold
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: AppinioSwiper(
              cardsCount: 15,
              onSwiping: (AppinioSwiperDirection direction) {
                if (direction == AppinioSwiperDirection.right) {
                    _nextBook = getNextBook(getUUID(), "true"); 
                } else {
                    _nextBook = getNextBook(getUUID(), "false"); 
                }
              },
              swipeOptions: AppinioSwipeOptions.symmetric(horizontal:true, vertical: false),
              cardsBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: CupertinoColors.lightBackgroundGray,
                  child: FutureBuilder<NextBook>(
                        // pass the list (postsFuture)
                        future: _nextBook,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // do something till waiting for data, we can show here a loader
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            //final bio = snapshot.data!.userBio;
                            final nextBook = snapshot.data!;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  // Handle "Dislike" action
                },
                icon: Icon(Icons.arrow_back, size: 32), // Arrow pointing left
                label: Text(
                  'Dislike',
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle "Like" action
                },
                icon: Icon(Icons.arrow_forward, size: 32), // Arrow pointing right
                label: Text(
                  'Like',
                  style: TextStyle(color: Colors.black), // Set text color to black
                ),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget buildNextBook(NextBook book) {
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
        return Card (
          elevation: 4.0,
          child: Column(
            children: [
              ListTile(
                title: Text(book.title),
                subtitle: Text("by: $book.author"),
                trailing: Icon(Icons.favorite_outline),
              ),
              Container(
                height: 200.0,
                child: Image.memory(
                  base64.decode(book.bookCover)
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