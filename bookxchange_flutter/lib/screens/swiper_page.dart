import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';

class BookSwiperScreen extends StatefulWidget {
  const BookSwiperScreen({super.key});

  @override
  State<BookSwiperScreen> createState() => _BookSwiperScreenState();
}

class _BookSwiperScreenState extends State<BookSwiperScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: AppinioSwiper(
          cardsCount: 15,
          onSwiping: (AppinioSwiperDirection direction) {
            print(direction.toString());
          },
          cardsBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              color: CupertinoColors.activeBlue,
              child: const Text('doesnt matter'),
            );
          },
        ),
      ),
    );
  }
}
