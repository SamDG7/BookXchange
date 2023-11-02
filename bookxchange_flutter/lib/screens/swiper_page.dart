import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:bookxchange_flutter/api/queue.dart';

class BookSwiperScreen extends StatefulWidget {
  const BookSwiperScreen({Key? key});

  @override
  State<BookSwiperScreen> createState() => _BookSwiperScreenState();
}

class _BookSwiperScreenState extends State<BookSwiperScreen> {
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
                print(direction.toString());
              },
              cardsBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: CupertinoColors.activeBlue,
                  child: const Text('Book Cover Image'), // You can replace this with an actual book cover image
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
}


 
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