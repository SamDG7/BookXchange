import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';

class AddBooktoLibraryScreen extends StatefulWidget {
  const AddBooktoLibraryScreen({super.key});

  @override
  State<AddBooktoLibraryScreen> createState() => _AddBooktoLibraryScreenState();
}

class _AddBooktoLibraryScreenState extends State<AddBooktoLibraryScreen> {

  late String title;
  late String author;
  late int year;
  late String genres;
  late Image bookCover;
  late String yourReview;
  late bool currentStatus;
  late int numSwaps;

  File? _image;
  final picker = ImagePicker();

  // get image from camera roll

  // get image from photo library

  //   screens/edit_profile_page.dart : Future<UpdateProfile>? _editProfile; WHICH IS ON api/user_profile.dart


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}