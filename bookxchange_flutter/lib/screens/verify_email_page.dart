import 'dart:async';

import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late Timer timer;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email Verification"),
        backgroundColor: butterfly,
      ),
      body: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Image.asset('assets/email_logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Text(
                    'An email has been sent to ${FirebaseAuth.instance.currentUser!.email}. Please verify this email address',
                    style: const TextStyle(
                        color: butterfly, fontWeight: FontWeight.bold)),
              ),
            ],
          )),
      // body: Center(
      //   child: Text(
      //       'An email has been sent to ${FirebaseAuth.instance.currentUser!.email}. Please verify this email address',
      //       style: TextStyle(color: butterfly, fontWeight: FontWeight.bold)),
      // ),
    );
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      timer.cancel();

      //SOME SORT OF ERROR CAUSED BY THIS THAT DOESNT ALLOW SIGN OUT ON HOME PAGE FUNCTIONALITY
      //FIX??:: PERHAPS JUST TELL USERS TO GO BACK AND LOGIN WITH THIER NEW ACCOUNT

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
