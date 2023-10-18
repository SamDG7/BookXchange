import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/messages_page.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:bookxchange_flutter/screens/swiper_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bookxchange_flutter/components/components.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late String _msg = "";
  late String _subject = "";
  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //final FirebaseUser user = await auth.currentUser();
  //final userid = user.uid;
  //function to sign the user out
  void signUserOut() async {
    print("Signing user out");
    final googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }

  Future reportIssue() async {
    // final smtpServer = gmail('bookxchangehelp@gmail.com', 'scrummasterpooja');
    const email = 'bookxchangehelp@gmail.com';
    const serviceId = 'service_7syjpzx';
    const templateId = 'template_bv4krke';
    const userId = 'VYsR9kMs96Fm7r3Ne';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'from_name': FirebaseAuth.instance.currentUser!.email,
          'user_email': FirebaseAuth.instance.currentUser!.email,
          'user_subject': _subject,
          'user_message': _msg,
        }
      }),
    );

    print(response.body);

    // final message = Message()
    //   ..from = const Address(email, ' BookXchange Support Ticket')
    //   ..subject = _subject
    //   ..text = _msg
    //   ..recipients.add('bookxchangehelp@gmail.com');

    // var smtpServer = gmail(email, 'scrummasterpooja');
    // try {
    //   final sendReport = await send(message, smtpServer);
    //   print(sendReport.toString());
    // } on MailerException catch (e) {
    //   print('Message not sent.');
    //   print(e.toString());
    // }
    // Navigator.pop(context);
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData =
          FirebaseAuth.instance.currentUser?.providerData.first;

      if ((providerData != null) &&
          (GoogleAuthProvider().providerId == providerData.providerId)) {
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      print("$e");
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      print("Firebase Authentication Exception: $e");

      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      }
    } catch (e) {
      print("General Exception: $e");
    }
  }

  //popup that tells user account has been deleted
  void successfullyDeletedAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Account Deleted",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Your account has been successfully deleted.",
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        "/")); // Close the success message dialog
                //account is deleted
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  //confirms that the user wants to delete their account
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
          content: Text("Are you sure you want to delete your account?",
              style: TextStyle(fontSize: 16)),
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
                successfullyDeletedAccount(context);
                deleteUserAccount();
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
              ),
              PopupMenuItem(
                value: MenuItem.item3,
                child: Text("Report an issue"),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Container(
                          padding: const EdgeInsets.all(80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Report an Issue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge),
                              Text(""),
                              Text("Please enter the category of the issue"),
                              Text(""),
                              CustomTextField(
                                textField: TextField(
                                  onChanged: (value) {
                                    // Set the user's email
                                    _subject = value;
                                  },
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  decoration: kTextInputDecoration.copyWith(
                                      hintText: 'Subject'),
                                ),
                              ),
                              Text(""),
                              Text(""),
                              Text(
                                  "Please provide the specifics of the issue below"),
                              Text(""),
                              Container(
                                width: 300,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 50,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2.5,
                                    color: butterfly,
                                  ),
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    // Set the user's email
                                    _msg = value;
                                  },
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                  decoration: kTextInputDecoration.copyWith(
                                      hintText: 'Comments'),
                                ),
                              ),
                              Text(""),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        butterfly, // Set the background color to blue
                                    minimumSize: const Size(100,
                                        50), // Set the button size (width x height)
                                  ),
                                  onPressed: reportIssue,
                                  child: const Text(
                                    "Submit Report",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )));
                },
              ),
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
