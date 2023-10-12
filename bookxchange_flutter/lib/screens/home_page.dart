import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/messages_page.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:bookxchange_flutter/screens/swiper_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final user = FirebaseAuth.instance.currentUser!;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(actions: [
//         IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
//       ]),
//       body: Center(child: Text("LOGGED IN AS " + user.email!)),
//     );
//   }

//   // function to sign the user out

// }

// class HomePage extends StatelessWidget {
//   HomePage({super.key});

//   final user = FirebaseAuth.instance.currentUser!;
//   //function to sign the user out
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(actions: [
//         IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
//       ]),
//       body: Center(child: Text("LOGGED IN AS ${user.email!}")),
//     );
//   }
// }
enum MenuItem { item1, item2, item3 }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Current screen index
  int screenIndex = 0;

  // List of screens to navigate to from the NavBar
  final screensToNavigateTo = const <Widget>[
    ProfileScreen(),
    BookSwiperScreen(),
    MessagesScreen(),
  ];

  final user = FirebaseAuth.instance.currentUser!;
  //function to sign the user out
  void signUserOut() async {
    print("Signing user out");
    final googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      print("Firebase Authentication Exception: $e");

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      print("General Exception: $e");

      // Handle general exception
    }
  }

  // Function to delete the user account
  void successfullyDeletedAccount(BuildContext context) {
    // Show a success message dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Account Deleted"),
          content: Text("Your account has been successfully deleted."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, ModalRoute.withName("/")); // Close the success message dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void deleteUserConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Deletion of Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete action here
                Navigator.of(context).pop(); // Close the dialog
                successfullyDeletedAccount(context);
                deleteUserAccount();
                // Add code to delete the account
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar for every page
      appBar: AppBar(
        // BookXchange logo
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
              //ADD DELETE CONFIRMATION POPUP
              PopupMenuItem(
                value: MenuItem.item2,
                child: Text('Delete Account'),
                onTap: () {
                  deleteUserConfirmationPopup(context);
                },
              )
            ],
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 35,
        ),
        backgroundColor: butterfly,
      ),

      // Switch screen displayed according to what icon pressed in NavBar
      body: screensToNavigateTo[screenIndex],

      // Nav bar on bottom of screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        onTap: (x) {
          setState(() {
            screenIndex = x;
          });
        },

        // Nav bar icons
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
        ],

        backgroundColor: butterfly,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 35,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
