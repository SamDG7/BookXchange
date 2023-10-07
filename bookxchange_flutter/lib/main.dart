
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/messages_page.dart';
import 'package:bookxchange_flutter/screens/profile_page.dart';
import 'package:bookxchange_flutter/screens/swiper_page.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookXchange App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  // Current screen index
  int screenIndex = 0;

  // List of screens to navigate to from the NavBar
  final screensToNavigateTo = const <Widget>[
    ProfileScreen(),
    BookSwiperScreen(),
    MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // App Bar for every page
      appBar: AppBar(

        // BookXchange logo
        leading: Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 10), child: Image.asset('assets/logo_no_text.png')),
        leadingWidth: 75,

        actions: <Widget>[
          IconButton(
            onPressed: () {}, // TODO: ADD ICON FUNCTIONALITY
            icon: const Icon(Icons.settings), // Settings icon
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 35,
          ),
        backgroundColor: butterfly,
      ),

      // Switch screen displayed according to what icon pressed in NavBar
      body: screensToNavigateTo[screenIndex],
  
      // Nav bar on bottom of screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: screenIndex,
        onTap: (x) {
          setState(() {
            screenIndex = x;
          });
        },

        // Nav bar icons
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
        ],

        backgroundColor: butterfly,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        iconSize: 35,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
