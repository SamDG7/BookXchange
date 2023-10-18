import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/api/library_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';



class LibraryGridState extends StatelessWidget {
  Library selectedLibrary;
  

  LibraryGridState({this.selectedLibrary});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(
          this.selectedLibrary.
        ),
      ),
    );
  }
}