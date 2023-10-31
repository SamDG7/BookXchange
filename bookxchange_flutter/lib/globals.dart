//global variables

import 'package:bookxchange_flutter/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';

bool newUser = false;
var profileImage = getProfilePicture(getUUID());
String isbn13 = '';

String getUUID() {
  //final User user = FirebaseAuth.instance.currentUser!;
  final uuid = FirebaseAuth.instance.currentUser!.uid;
  return uuid;
}

String getImageURL(String uuid) {
  // return ('http://127.0.0.1:8080/user/get_picture/''$uuid');
  return ('http://10.0.2.2:8080/user/get_picture/' '$uuid');
}
