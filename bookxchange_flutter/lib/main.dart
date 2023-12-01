import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/create_profile_page.dart';
import 'package:bookxchange_flutter/screens/messages_page.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:bookxchange_flutter/screens/swiper_page.dart';
import 'package:open_library/open_library.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'api/firebase_api.dart';

//final navigatorKey = GlobalKey<NavigatorState>();
final _firebaseMessaging = FirebaseMessaging.instance;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Title ${message.notification?.body}');
  print('Title ${message.data}');
}

void handleMessage(RemoteMessage? message) {
  if (message == null) return;
}

Future initPushNotifications() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _firebaseMessaging.requestPermission();
  final fCMToken = await _firebaseMessaging.getToken();
  print('FCM Token: $fCMToken');
  initPushNotifications();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // String? fcmToken = await FirebaseMessaging.instance.getToken();
  // print('FCM Token: $fcmToken');

  // // Initialize Firebase Messaging
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   // Handle the incoming message when the app is in the foreground
  //   print('Received message: $message');
  // });

  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //   // Handle the incoming message when the app is in the background and opened by the user
  //   print('Opened app from background message: $message');
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => OpenLibrary(),
      dispose: (_, OpenLibrary service) => service.dispose(),
      child: MaterialApp(
        title: 'BookXchange App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        //home: CreateProfileScreen(),
        home: AuthPage(),
        //navigatorKey: navigatorKey,
      ),
    );
  }
}
