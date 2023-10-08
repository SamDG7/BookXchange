import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bookxchange_flutter/api/user_account.dart';

class AuthService {
    //google sign in
  // static String getUUID()  {
  //   //final User user = FirebaseAuth.instance.currentUser!;
  //   // ignore: await_only_futures
  //   String? uuid = FirebaseAuth.instance.currentUser?.uid;
  //   return uuid;
  // }

  signInWithGoogle() async {
    try {
    //begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    
    //obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    
    //create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken, 
      idToken: gAuth.idToken
    );
    
    // try {
    //   await FirebaseAuth.instance.signInWithCredential(credential);
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
    // //sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
    //return FirebaseAuth.instance.currentUser?.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
