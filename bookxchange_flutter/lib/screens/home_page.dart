import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  void signUserOut() async {
    final googleSignIn = GoogleSignIn();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
      ]),
      body: Center(child: Text("LOGGED IN AS ${user.email!}")),
    );
  }
}
