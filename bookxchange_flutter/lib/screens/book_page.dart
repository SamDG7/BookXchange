import 'package:bookxchange_flutter/api/user_account.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/material.dart';

class BookAboutScreen extends StatefulWidget {
  const BookAboutScreen({super.key});

  @override
  State<BookAboutScreen> createState() => _BookAboutScreenState();
}

class _BookAboutScreenState extends State<BookAboutScreen> {
  //Future<ExistingUser>? _existingUser = getUserLogin(getUUID());

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
                // FutureBuilder<ExistingUser>(
                //           // pass the list (postsFuture)
                //           future: _existingUser,
                //           builder: (context, snapshot) {
                //             if (snapshot.connectionState ==
                //                 ConnectionState.waiting) {
                //               // do something till waiting for data, we can show here a loader
                //               return const CircularProgressIndicator();
                //             } else if (snapshot.hasData) {
                //               final title = snapshot.data!.title;
                //               return buildTitle(title);
                //               // Text(posts);
                //               // we have the data, do stuff here
                //             } else {
                //               return const Text("No title available");
                //               // we did not recieve any data, maybe show error or no data available
                //             }
                //           }),

                Text(
                  "Watership Down",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "By Richard Adams",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  "1972",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Image.asset(
                    'assets/book_cover_watership_down.png',
                    height: 200,
                    fit: BoxFit.fill,
                  ),
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
                  "Statistics",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Status:", //swapped or in library
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Number of Swaps:",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Time on Profile:",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
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
                  children: [ Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: OutlinedButton.icon(
                      onPressed: () {
                        //Navigator.push(
                        //    context,
                        //    MaterialPageRoute(
                        //         builder: (context) => BookAboutScreen()),
                        // add screen to edit library here
                        //     );
                      },
                      icon: Icon(
                        Icons.remove,
                        color: butterfly,
                      ),
                      label: Text(
                        'Remove book from library',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: butterfly),
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

  Widget buildTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.left,
      softWrap: true,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
