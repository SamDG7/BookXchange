import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:bookxchange_flutter/globals.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _preferredGenres = [];

  void _itemChange(String genre, bool isSelected) {
    setState(() {
      if (isSelected) {
        _preferredGenres.add(genre);
      } else {
        _preferredGenres.remove(genre);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _preferredGenres);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Genres',
        style: TextStyle(
          color: butterfly,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          //tileColor: isSelected ? Colors.blue : null,
          children: widget.items
              .map((item) => CheckboxListTile.adaptive(
                    value: _preferredGenres.contains(item),
                    selectedTileColor: butterfly,
                    title: Text(
                      item,
                      style: TextStyle(
                          //color: white,
                          ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class AddBooktoLibraryScreen extends StatefulWidget {
  const AddBooktoLibraryScreen({super.key});

  @override
  State<AddBooktoLibraryScreen> createState() => _AddBooktoLibraryScreenState();
}

class _AddBooktoLibraryScreenState extends State<AddBooktoLibraryScreen> {
  late String title = '';
  late String author = '';
  late int year;
  late String ISBN = '';
  late List<String> genres;
  //late Image bookCover;
  late String yourReview;
  late bool currentStatus =
      true; // status is TRUE because the book is IN the user's home
  late int numSwaps = 0;
  List<String> _preferredGenres = [];

  //File? _image;

  File? bookCover;
  final picker = ImagePicker();

  Future<Book>? _newBook;

  // get image from camera roll

  // get image from photo library

  //   screens/edit_profile_page.dart : Future<UpdateProfile>? _editProfile; WHICH IS ON api/user_profile.dart

  bool checkNullValue() {
    if (title.isEmpty) {
      return false;
    }
    if (author.isEmpty) {
      return false;
    }
    if (ISBN.length < 13) {
      return false;
    }
    return true;
  }

  void _showMultiSelect() async {
    final List<String> items = [
      'Crime and Mystery',
      'Fantasy',
      'Historical',
      'Horror',
      'Romance',
      'Science Fiction',
      'Thriller',
      'Young-adult',
      'New-adult',
      'Biography',
      'Paranormal',
      'Classics',
    ];

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(items: items);
        });

    if (results != null) {
      setState(() {
        _preferredGenres = results;
      });
    }
  }

  void successfullyCreatedBook(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book Created'),
          content: Text('Your book has successfully been added!',
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void addBookConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Creation of Book",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to create this book?", style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                successfullyCreatedBook(context);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Add Book',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Row(
              //PUT ADD PICTURE STUFF HERE
              ),
          SizedBox(height: 200),
          Column(
            /* 
            /// USE THIS FOLLOWING CODE FOR ALL THE VARIABLES SHOWN ABOVE WHEN INTERING BUTTON OR TEXTFIELD INFO 

            onChanged: (value) {
                 title = value;
               },

            /// USE THIS WHEN ALL VALUES HAVE BEEN SET TO CREATE THE BOOK
            _newBook = createBook(getUUID(),  title, author, year, genres, bookCover, yourReview, currentStatus, numSwaps); 
             */

            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 2, color: butterfly),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: butterfly),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "Title",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    author = value;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 2, color: butterfly),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: butterfly),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "Author",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  maxLines: null,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    ISBN = value;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 13,
                  decoration: InputDecoration(
                    counterText: "",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(width: 2, color: butterfly),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(20),
                      ),
                      borderSide: BorderSide(color: butterfly),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    labelText: "ISBN-13",
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // use this button to open the multi-select dialog
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: butterfly,
                      ),
                      onPressed: _showMultiSelect,
                      child: const Text(
                        "Select your genres",
                        style: TextStyle(
                          color: Colors.white, // Set the text color to white
                          fontSize: 18, // Set the text size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    // display selected items
                    Wrap(
                      children: _preferredGenres
                          .map((e) => Chip(
                                label: Text(
                                  e,
                                  style: TextStyle(
                                    color:
                                        butterfly, // Set the text color to white
                                    fontSize: 14, // Set the text size
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 100),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 10, 100),
                child: ElevatedButton(
                  //TRIGGER SAVE POPUP AND EXIT
                  onPressed: () {
                    if (checkNullValue() == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Container(
                              padding: const EdgeInsets.all(19),
                              height: 80,
                              decoration: const BoxDecoration(
                                  color: butterfly,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const Text(
                                  "Make sure to fill in all the fields!",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16))),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      //ADD BOOK HAS BEEN SAVED HERE
                      addBookConfirmationPopup(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: butterfly,
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
