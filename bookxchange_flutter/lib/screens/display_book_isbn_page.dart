import 'package:open_library/models/ol_book_model.dart';
import 'package:open_library/models/ol_search_model.dart';
import 'package:bookxchange_flutter/api/book_profile.dart';
import 'package:open_library/open_library.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookxchange_flutter/globals.dart';



//const ISBN = isbn13;



// class FirstScreen extends StatelessWidget {
//   const FirstScreen({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Provider(
//         create: (_) => OpenLibrary(),
//         dispose: (_, OpenLibrary service) => service.dispose(),
//         child: MaterialApp(
//           title: 'Book Example',
//           home: DisplayBookISBNScreen()
//         ));
//   }
// }


//class DisplayBookISBNScreen extends StatelessWidget {
class DisplayBookISBNScreen extends StatefulWidget {
  DisplayBookISBNScreen({Key? key}) : super(key: key);

  final List<OLBook> books = [];

  @override
  State<DisplayBookISBNScreen> createState() => _DisplayBookISBNScreenState();
}
  //const DisplayBookISBNScreen({super.key, required this.isbn13});
  //final String isbn13;

class _DisplayBookISBNScreenState extends State<DisplayBookISBNScreen> {

  late bool isLoading = false;
  //final String isbn13 = '';


 @override

Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey,
       appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Add Book via ISBN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: !isLoading
          ? Column(
              children: [
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                 SizedBox(
                  height: 20.0,
                ),
                 Center(
                    child: Text(
                      "press action button to search for those ISBN's",
                      style: TextStyle(color: Colors.white),
                    )),
                 SizedBox(
                  height: 20.0,
                ),
                 Center(
                  //   child: Text(
                  // "ISBN:$isbn13",
                  // style: TextStyle(color: Colors.white),
                   child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextField(
                  onChanged: (value) {
                    isbn13 = value;
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
                 ),
                //)
         
                // const SizedBox(height: 20.0),
                // const Center(
                //     child: Text(
                //   "ISBN2:$ISBN2",
                //   style: TextStyle(color: Colors.white),
                // )),
                // const SizedBox(height: 20.0),
                // const Center(
                //     child: Text(
                //   "ISBN3:$ISBN3",
                //   style: TextStyle(color: Colors.white),
                // )),
                const SizedBox(height: 20.0),
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.books.length,
                    itemBuilder: (context, index) {
                      return bookWidget(
                          book: widget.books[index], context: context);
                    },
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator(color: butterfly,)),
          //elevatedActionButtion: ElevatedButton(
            // children: [
            //   ElevatedButton (
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          widget.books.clear();
          const bool loadCovers = true;
          const CoverSize size = CoverSize.L;
          

          final OLBookBase book1 =
              await Provider.of<OpenLibrary>(context, listen: false)
                  .getBookByISBN(
                      isbn: isbn13, loadCover: loadCovers, coverSize: size);
        // SizedBox(height: 25);
        // Padding(
        //         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        
        //         child: ElevatedButton(
        //           //TRIGGER SAVE POPUP AND EXIT
        //           onPressed: () {
        //                 print("save book");
        //           },
        //           style: ElevatedButton.styleFrom(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(20),
        //             ),
        //             backgroundColor: butterfly,
        //           ),
        //           child: Text(
        //             "Save",
        //             style: TextStyle(fontSize: 18, color: Colors.white),
        //           ),
        //         ),
        //       );
          print(book1.toString());
          if (book1 is OLBook) {
            widget.books.add(book1);
          } else {
          
  
          // if (book1 == null) {
            //if (book1.is)
            //if (book1 == Error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Container(
                              padding: const EdgeInsets.all(19),
                              height: 60,
                              decoration: const BoxDecoration(
                                  color: butterfly,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: const Text(
                                  "Please Enter a Valid ISBN!",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                                      alignment:Alignment.center
                                      ),
                          duration: Duration(seconds: 2),
                        ),
                      );
          }
          setState(() {
            isLoading = false;
          });    
        print("this is an error in creating the book");   
        },
        backgroundColor: butterfly,
        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
        // child: Text(
        //   "Save",
        //   style: TextStyle(fontSize: 18, color: Colors.white),
        // ),
      child: const Icon(
        Icons.search,
        color: Colors.white,
        ),
      ),
            //],
    );
  }
  Widget bookWidget({required OLBook book, required BuildContext context}) {
    Future<Book>? _newBook;
    String author = '';
    if (book.authors.isNotEmpty) {
      author = book.authors.first.name.trim();
    }
    String publish_date = book.publish_date;
    List<String> genres = book.subjects;
    if (book.covers.isNotEmpty) {
      Image.memory(book.covers.first);
    }
    //return Row (
      //children: [
   return Stack (
   children: [
    Padding(
      padding: const EdgeInsets.all(3.0),
      
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: 300.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Expanded (
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Expanded(
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      book.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                //),
                ),
                //Expanded(
                  Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 20.0),
                  child:
                   Text(
                    author,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
               // ),
                
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, bottom: 4.0, left: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "Publish Date: $publish_date",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          //fontWeight: FontWeight.bold
                          ),
                    ),
                  ),
                ),
                //),
                //Expanded(
                Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                      // child: ListView.builder(
                      //   padding: const EdgeInsets.all(8),
                      //   itemCount: book.subjects.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return Text( book.subjects[index]);
                      //   }
                      //   ),
                    child: Text(
                      //"Genres/Subjects: $genres",
                      genres.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                //),
                ),
                //Expanded(
                  Padding(
                  padding:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      book.publishers[0],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //),
              ],
            //),
            ),
            //Expanded(
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SizedBox(
                height: book.covers.isNotEmpty ? 140.0 : 130,
                child: book.covers.isNotEmpty
                    ? Image.memory(book.covers.first)
                    : null,
              ),
            ),
            //),
          ],
          
      
        ),

      ),

    ),
    SizedBox(height: 25),
    Padding(
                padding: EdgeInsets.fromLTRB(150, 250, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    _newBook = createBook(getUUID(), book.title, author, isbn13, genres);
                    Navigator.of(context).pop();
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
   );


      
      //  SizedBox(height: 25,
      //   child: const DecoratedBox(
      //     decoration: const BoxDecoration(
      //     color: Colors.black
      //   ),
      //    ),),
      //   Padding(
      //           padding: EdgeInsets.fromLTRB(0, 300, 0, 0),
        
      //           child: ElevatedButton(
      //             //TRIGGER SAVE POPUP AND EXIT
      //             onPressed: () {
      //                   print("save book");
      //             },
      //             style: ElevatedButton.styleFrom(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(20),
      //               ),
      //               backgroundColor: butterfly,
      //             ),
      //             child: Text(
      //               "Save",
      //               style: TextStyle(fontSize: 18, color: Colors.white),
      //             ),
      //           ),
      //         ),
     //  ],
    //);


  }


  //State<DisplayBookISBNScreen> createState() => _DisplayBookISBNScreenState();
}