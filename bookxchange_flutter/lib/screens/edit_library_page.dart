import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/api/display_library.dart';
import 'dart:convert';
import 'package:bookxchange_flutter/constants.dart';

class EditLibraryScreen extends StatefulWidget {
 const EditLibraryScreen({super.key});

  @override
  State<EditLibraryScreen> createState() => _EditLibraryScreenState();
}

class _EditLibraryScreenState extends State<EditLibraryScreen> {
  Future<List<LibraryBooks>>? _userLibrary = getLibraryBooks(getUUID());
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Edit Library',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Vertical scrollable layout
      // body: ListView(
      //   children: <Widget>[
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
        body: Center(
              // Padding(
              //   padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                  child: FutureBuilder<List<LibraryBooks>>(
                    future: _userLibrary,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final books = snapshot.data!;
                        return buildLibrary(books);
                      } else {
                        return const Text("No data available");
                      }
                    },
                  ),
            //   ),
            // ],
          //),
        //],
      //),
        ),
);
  }

Widget buildLibrary(List<LibraryBooks> library) {
    // ListView Builder to show data in a list
    return GridView.builder(
      scrollDirection: Axis.vertical,
      //shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        crossAxisSpacing: 2.0, // Spacing between columns
        mainAxisSpacing: 10.0, // Spacing between rows
      ),
      itemCount: library.length,
      itemBuilder: (context, index) {
          final book = library[index];
          return GestureDetector(
            onTap: () {
              print(book.bookUID);
            },
            child: Image.memory(
          base64.decode(book.bookCover),
          )
        );
      },
    );
  }
}