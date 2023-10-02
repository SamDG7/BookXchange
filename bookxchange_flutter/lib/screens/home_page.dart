import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
//   void signUserOut() {
//     FirebaseAuth.instance.signOut();

//     // Navigator.of(context).pushReplacement(
//     //     MaterialPageRoute(builder: (context) => LoginSignupScreen()));
//   }
// }

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  //function to sign the user out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
      ]),
      body: Center(child: Text("LOGGED IN AS " + user.email!)),
    );
  }
}
