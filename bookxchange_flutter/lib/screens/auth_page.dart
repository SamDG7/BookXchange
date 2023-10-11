import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:bookxchange_flutter/screens/create_profile_page.dart';

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
                // debugPrint(newUser as String?);
                if (newUser == true) {
                  newUser = false;
                  return const CreateProfileScreen();
                } else {
                  return const HomePage();
                }
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
