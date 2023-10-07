import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';

import 'package:bookxchange_flutter/screens/verify_email_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                return HomePage();
              } else {
                return const VerifyScreen();
              }
            } else {
              return const LoginSignupScreen();
            }
          }),
    );
  }
}
