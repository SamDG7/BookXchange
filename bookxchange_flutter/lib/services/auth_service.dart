import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bookxchange_flutter/api/user_account.dart';

class AuthService {
  
  //google sign in
  static String getUUID()  {
    //final User user = FirebaseAuth.instance.currentUser!;
    // ignore: await_only_futures
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    return uuid;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: butterfly,
      content: Text(
        content,
        style: TextStyle(color: Colors.white, letterSpacing: 0.5),
      ),
    );
  }

  signInWithGoogle(BuildContext context) async {
    try {
      //begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      //obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      //create a new credential for the user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      //sign in
      //return await FirebaseAuth.instance.signInWithCredential(credential);
      UserCredential newuser = await FirebaseAuth.instance.signInWithCredential(credential);

      Future<NewUser>? _futureUser;
      _futureUser = createUser(getUUID(), "hi");
      return newuser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content: 'The account already exists with a different credential',
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          AuthService.customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthService.customSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
        ),
      );
    }
  }
}
