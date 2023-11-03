import 'dart:async';
import 'dart:convert';

import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:bookxchange_flutter/api/user_account.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:bookxchange_flutter/screens/edit_book_page.dart';
import 'package:bookxchange_flutter/screens/edit_library_page.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:flutter/material.dart';

class BookAboutScreen extends StatefulWidget {
  const BookAboutScreen({super.key});

  @override
  State<BookAboutScreen> createState() => _BookAboutScreenState();
}

//popup that allows user to change book status
Future<String> _showStatusDialog(BuildContext context) {
  Completer<String> completer = Completer<String>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Center(
          child: Text('Book Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => BookAboutScreen()));

              completer.complete('Available');
            },
            child: Text('Available',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => BookAboutScreen()));
              completer.complete('Out for Loan');
            },
            child: Text('Out for Loan',
                style: TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ],
      );
    },
  );
  return completer.future;
}

class _BookAboutScreenState extends State<BookAboutScreen> {
  Future<Book>? _currentBook = getBook(currentBookUID);
  Future<BookCoverImage>? _currentBookCover =
      getBookCoverPicture(currentBookUID, getUUID());
  //Future<Book> _currentBook = currentBookUID;
  late String bookStatus = '';
  late bool isLoading = false;
  Future<BookStatus>? _updateBookStatus;


  void successfullyDeletedBook(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Book Deleted'),
          content: Text('Your book has successfully been deleted!',
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  HomePage()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deleteBookConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Deletion of Book",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to delete this book?", style: TextStyle(fontSize: 16)),
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
                successfullyDeletedBook(context);
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
          'Your Book',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Vertical scrollable layout
      body: ListView(
        // Profile image, profile name, join date, edit profile button, share profile
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              children: [
                // FutureBuilder<Book>(
                //           future: _currentBook,
                //           builder: (context, snapshot) {
                //             if (snapshot.connectionState ==
                //                 ConnectionState.waiting) {
                //               // do something till waiting for data, we can show here a loader
                //               return const CircularProgressIndicator();
                //             } else if (snapshot.hasData) {
                //               final title = snapshot.data!.title;
                //               return buildTitle(title);
                //               // we have the data, do stuff here
                //             } else {
                //               return const Text("No title available");
                //               // we did not recieve any data, maybe show error or no data available
                //             }
                //           }),

                //TODO: DO THIS FOR ALL
                FutureBuilder<Book>(
                    // pass the list (postsFuture)
                    future: _currentBook,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // do something till waiting for data, we can show here a loader
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final title = snapshot.data!.title;
                        //return buildName(name);
                        return Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                        // Text(posts);
                        // we have the data, do stuff here
                      } else {
                        return const Text("No title available");
                        // we did not recieve any data, maybe show error or no data available
                      }
                    }),
                FutureBuilder<Book>(
                    // pass the list (postsFuture)
                    future: _currentBook,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // do something till waiting for data, we can show here a loader
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final author = snapshot.data!.author;
                        //return buildName(name);
                        return Text(
                          "by $author",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        );
                        // Text(posts);
                        // we have the data, do stuff here
                      } else {
                        return const Text("No author available");
                        // we did not recieve any data, maybe show error or no data available
                      }
                    }),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: FutureBuilder<BookCoverImage>(
                        // pass the list (postsFuture)
                        future: _currentBookCover,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // do something till waiting for data, we can show here a loader
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasData) {
                            //final bio = snapshot.data!.userBio;
                            final coverPicture = snapshot.data!;
                            return buildPicture(coverPicture);
                            // Text(posts);
                            // we have the data, do stuff here
                          } else {
                            return const Text("No image available");
                            // we did not recieve any data, maybe show error or no data available
                          }
                        })
                    // child: Image.asset(
                    //   'assets/book_cover_watership_down.png',
                    //   height: 200,
                    //   fit: BoxFit.fill,
                    // ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        //Navigator.push(
                        //    context,
                        //    MaterialPageRoute(
                        //         builder: (context) => BookAboutScreen()),
                        // add screen to edit library here
                        //     );
                      },
                      icon: Icon(
                        Icons.read_more,
                        color: butterfly,
                      ),
                      label: Text(
                        'See More',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: butterfly),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        //Navigator.push(
                        //    context,
                        //    MaterialPageRoute(
                        //         builder: (context) => BookAboutScreen()),
                        // add screen to edit library here
                        //     );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditBookScreen()),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: butterfly,
                      ),
                      label: Text(
                        'Edit Book',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: butterfly),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "More Details:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                FutureBuilder<Book>(
                    // pass the list (postsFuture)
                    future: _currentBook,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // do something till waiting for data, we can show here a loader
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final bookStatus = snapshot.data!.bookStatus;
                        //return buildName(name);
                        return Text(
                          "Status: $bookStatus",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        );
                        // Text(posts);
                        // we have the data, do stuff here
                      } else {
                        return const Text("No status available");
                        // we did not recieve any data, maybe show error or no data available
                      }
                    }),
                FutureBuilder<Book>(
                    // pass the list (postsFuture)
                    future: _currentBook,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // do something till waiting for data, we can show here a loader
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final isbn13 = snapshot.data!.isbn13;
                        //return buildName(name);
                        return Text(
                          "ISBN Number: $isbn13",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        );
                        // Text(posts);
                        // we have the data, do stuff here
                      } else {
                        return const Text("No ISBN number available");
                        // we did not recieve any data, maybe show error or no data available
                      }
                    }),
                FutureBuilder<Book>(
                    // pass the list (postsFuture)
                    future: _currentBook,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // do something till waiting for data, we can show here a loader
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final genres = snapshot.data!.genres;
                        //return buildName(name);
                        return Text(
                          "Genres: $genres",
                          style: TextStyle(
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
                        );
                        // Text(posts);
                        // we have the data, do stuff here
                      } else {
                        return const Text("No status available");
                        // we did not recieve any data, maybe show error or no data available
                      }
                    }),
                SizedBox(height: 10),
                Text(
                  "Your Review:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  " 'Hi I thought this book was absolutely awesome! My dad read it to me and my siblings when we were little and rereading it now has been just as fun as the first time.'  🐰🐰🤼‍♀️\n- Elena ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                      child: OutlinedButton.icon(
                        onPressed: () {







                          deleteBookConfirmationPopup(context);
                          deleteBookFromLibrary(getUUID(), currentBookUID);
                          deleteBookFromCollection(currentBookUID);
                          










                        },
                        icon: Icon(
                          Icons.remove,
                          color: butterfly,
                        ),
                        label: Text(
                          'Remove Book',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: butterfly),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 15, 0),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          bookStatus = await _showStatusDialog(context);
                          _updateBookStatus =
                              updateBookStatus(currentBookUID, bookStatus);
                          print(bookStatus);
                        },
                        icon: Icon(
                          Icons.edit,
                          color: butterfly,
                        ),
                        label: Text(
                          'Change Book Status',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: butterfly),
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPicture(BookCoverImage coverImage) {
    // ignore: unnecessary_null_comparison
    return Container(
        width: 250,
        height: 250,
        child: Image.memory(base64.decode(coverImage.bookPicture)));
  }

}
