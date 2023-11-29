import 'package:bookxchange_flutter/screens/mod_user_page.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/api/moderator_view.dart';
import 'dart:convert';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModHomePage extends StatefulWidget {
  const ModHomePage({super.key});

  @override
  State<ModHomePage> createState() => _ModHomePageState();
}

class _ModHomePageState extends State<ModHomePage> {
  Future<List<ModUser>>? _userList = getUserList();

  final user = FirebaseAuth.instance.currentUser!;
  //late String _msg = "";
  //late String _subject = "";
  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //final FirebaseUser user = await auth.currentUser();
  //final userid = user.uid;
  //function to sign the user out
  void signUserOut() async {
    print("Signing user out");
    //final googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    //await googleSignIn.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: null,
        automaticallyImplyLeading: false,

        //leading: null,
        //automaticallyImplyLeading: false,
        leading: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
            child: Image.asset('assets/logo_no_text.png')),
        leadingWidth: 75,

        actions: <Widget>[
          PopupMenuButton<MenuItem>(
            onSelected: (value) {
              if (value == MenuItem.item1) {
                signUserOut();
                // Navigator.of(context)
                //   .push(MaterialPageRoute(builder: (context) => LoginSignupScreen()));
              }
            },
            icon: const Icon(Icons.settings), // Settings icon
            itemBuilder: (context) => [
              PopupMenuItem(value: MenuItem.item1, child: Text('Log Out')),
            ],
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 35,
        ),
        // backgroundColor: butterfly,
        backgroundColor: butterfly,
        title: Text(
          'User List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
              child: Padding(
                 padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: FutureBuilder<List<ModUser>>(
                    future: _userList,
                    builder: (context, snapshot) {
                      //print(_userList[0]);
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                          final users = snapshot.data!;
                          return buildUserList(users);
                      } else {
                        //print(_userList[0]);
                        return const Text("No data available");
                      }
                    },
                  ),
        ),
            //   ),
            // ],
          //),
        //],
      //),
        ),
    );
  }


  Widget buildUserList(List<ModUser> user_list) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: user_list.length,
      //itemCount: user_list.length,
      itemBuilder: (context, index) {
          final user = user_list[index];
          return ListTile(
            title: Text(user.userEmail),
            //title: Text("hi"),
            onTap: (){
              //print(user.uuid);
              modUserID = user.uuid;
              print(modUserID);
              Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ModUserScreen()),
              );
            }

          );
      } 
              //currentBookUID = book.bookUID;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => BookAboutScreen()),

                // add screen to edit library here
              );
              
              // Navigator.push(
              //   context, 
              //   MaterialPageRoute(builder: (context) => BookAboutScreen()),
              // );
    //         },
    //         child: Image.memory(
    //       base64.decode(book.bookCover),
    //       )
    //     );
    //   },
    // );
  }
}