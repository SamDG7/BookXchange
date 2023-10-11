import 'package:bookxchange_flutter/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    

    //print(gAuth.idToken);
    
    // try {
    //   await FirebaseAuth.instance.signInWithCredential(credential);
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
    // //sign in
    //User newuser = await FirebaseAuth.instance.signInWithCredential(credential);
    UserCredential newuser = await FirebaseAuth.instance.signInWithCredential(credential);

    Future<NewUser>? _futureUser;
    _futureUser = createUser(getUUID(), "hi");
    //newUser = task.getResult().getAdditionalUserInfo().isNewUser();
    //newUser = FirebaseAnalytics.instance.getAdditionalUserInfo.isNewUser();
    
    //return await FirebaseAuth.instance.signInWithCredential(credential);
    //return FirebaseAuth.instance.currentUser?.uid;
    return newuser;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
