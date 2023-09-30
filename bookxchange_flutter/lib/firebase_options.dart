// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD5HbjEUI32gZ0WOgWKBTwxNgn4Qdtrqj4',
    appId: '1:738603131874:web:45cf379479a1666ecd4fbb',
    messagingSenderId: '738603131874',
    projectId: 'bookxchange-70fb5',
    authDomain: 'bookxchange-70fb5.firebaseapp.com',
    storageBucket: 'bookxchange-70fb5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCfntHXGzs4fvOeZ9RjDr_myee4ch43CQ',
    appId: '1:738603131874:android:22e3f9f732dda082cd4fbb',
    messagingSenderId: '738603131874',
    projectId: 'bookxchange-70fb5',
    storageBucket: 'bookxchange-70fb5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDss9m8gjMaHq4jZJWrqlUtT5oAPT1Nkrk',
    appId: '1:738603131874:ios:c2ce1957edb0d39ccd4fbb',
    messagingSenderId: '738603131874',
    projectId: 'bookxchange-70fb5',
    storageBucket: 'bookxchange-70fb5.appspot.com',
    iosBundleId: 'com.example.bookxchangeFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDss9m8gjMaHq4jZJWrqlUtT5oAPT1Nkrk',
    appId: '1:738603131874:ios:a640abdcfe5de17fcd4fbb',
    messagingSenderId: '738603131874',
    projectId: 'bookxchange-70fb5',
    storageBucket: 'bookxchange-70fb5.appspot.com',
    iosBundleId: 'com.example.bookxchangeFlutter.RunnerTests',
  );
}
