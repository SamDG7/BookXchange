import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  const BookTile({super.key, required this.book, required this.press});

  final Book book;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(),
    );
  }
}