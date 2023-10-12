//global variables

import 'package:bookxchange_flutter/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool newUser = false;

String getUUID() {
    //final User user = FirebaseAuth.instance.currentUser!;
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    return uuid;
  }
