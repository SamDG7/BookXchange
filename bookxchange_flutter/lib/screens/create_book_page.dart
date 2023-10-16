import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:flutter/material.dart';

class AddBooktoLibraryScreen extends StatefulWidget {
  const AddBooktoLibraryScreen({super.key});

  @override
  State<AddBooktoLibraryScreen> createState() => _AddBooktoLibraryScreenState();
}

class _AddBooktoLibraryScreenState extends State<AddBooktoLibraryScreen> {
  late String title;
  late String author;
  late int year;
  late List<String> genres;
  late Image bookCover;
  late String yourReview;
  late bool currentStatus = true; // status is TRUE because the book is IN the user's home
  late int numSwaps = 0;

  //File? _image;
  //final picker = ImagePicker();

  Future<CreateBook>? _newBook;

  // get image from camera roll

  // get image from photo library

  //   screens/edit_profile_page.dart : Future<UpdateProfile>? _editProfile; WHICH IS ON api/user_profile.dart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Column(
            /* 
            /// USE THIS FOLLOWING CODE FOR ALL THE VARIABLES SHOWN ABOVE WHEN INTERING BUTTON OR TEXTFIELD INFO 

            onChanged: (value) {
                 title = value;
               },

            /// USE THIS WHEN ALL VALUES HAVE BEEN SET TO CREATE THE BOOK
            _newBook = createBook(getUUID(),  title, author, year, genres, bookCover, yourReview, currentStatus, numSwaps); 
             */

          ),
        ],
      ),
    );
  }
}
