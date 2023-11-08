import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/components/square_tile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/screens/mod_page.dart';
import 'package:bookxchange_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/api/user_account.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

// Stateful Widget
class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});
  static String id = 'login_signup_screen';

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

// Login Signup Screens process
class _LoginSignupScreenState extends State<LoginSignupScreen> {
  Future<NewUser>? _futureUser;
  late Future<ExistingUser> futureUser;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // @override
  // void initState() {
  //   super.initState();
  //   futureUser = getUserLogin(getUUID());
  // }
  // Variables to be used throughout the login/signup process
  //final _auth = FirebaseAuth.instance;
  late String _email;
  late String _phoneNumber;
  late String _password;
  late String _confirmpassword;
  final bool _saving = false;

  bool _signingup = false;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void checkSignUpIn() {
    if (_signingup) {
      signUserUp();
    } else {
      signUserIn();
    }
  }
  //method to setup account for users

  bool checkForValidPass() {
    final numericRegex = RegExp(r'[0-9]');
    if (_password.length < 8) {
      return false;
    }
    if (!numericRegex.hasMatch(_password)) {
      return false;
    }

    return true;
  }

  static String getUUID() {
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    return uuid;
  }

  void resetPassword() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
    Navigator.pop(context);
  }

  void signUserUp() async {
    if (checkForValidPass() && _password == _confirmpassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        _futureUser = createUser(getUUID(), _email);
        newUser = true;

        _firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': _email,
        });
      } on FirebaseAuthException catch (e) {
        //WRONG LOGIN CREDENTIALS
        print(e.code);
        if (e.code == 'email-already-in-use') {
          emailAlreadyInUse();
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          wrongEmailMessage();
          print('WRONG Something');
          print(e.code);
        }
      }
    } else {
      if (checkForValidPass() == false) {
        badPassword();
      } else {
        passwordsNoMatch();
      }
    }
    //try sign up
  }

  void emailAlreadyInUse() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Account Already Exists with these Credentials'),
        );
      },
    );
  }

  void passwordsNoMatch() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Passwords do not match'),
        );
      },
    );
  }

  //method to sign in users (firebaseAuth)
  void signUserIn() async {
    //try sign in
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      // Navigator.pop(context);
      futureUser = getUserLogin(getUUID());

      _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': _email,
      }, SetOptions(merge: true));

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      //WRONG LOGIN CREDENTIALS
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        wrongEmailMessage();
        print('WRONG Something');
      }
    }
  }

  //method to sign in moderators (firebaseAuth)
  void signModIn() async {
    //try sign in
    try {
      // need to indicate mod credentials somehow

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      // Navigator.pop(context);
      futureUser = getUserLogin(getUUID());
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ModHomePage()));
    } on FirebaseAuthException catch (e) {
      //WRONG LOGIN CREDENTIALS
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        wrongEmailMessage();
        print('WRONG Something');
      }
    }
  }

  //pop up for when the wrong email is entered
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email or Password'),
        );
      },
    );
  }

  void badPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
              'Password must be at least 8 characters in length and contain at least one number'),
        );
      },
    );
  }

  //////////////////////////////
  // UI
  //////////////////////////////
  ///
  @override
  Widget build(BuildContext context) {
    TextStyle linkStyle = TextStyle(
        color: butterfly, fontSize: 15.0, fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(),

      // Login/Signup page is divided into a column with different containers stacked vertically
      body: Column(
        children: [
          // Display logo above login/sign up bar options
          SizedBox(
            height: 100,
            child: Image.asset('assets/logo_with_text_compressed.png'),
          ),

          // Pad the container holding the login/sign up options
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height - 510,

              // Surround the login/sign up options with a border
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: butterfly, // Border color
                  width: 3.0, // Border width
                ),
              ),

              child: DefaultTabController(
                length: 2, // 2 tabs

                child: Column(
                  // Login/sign up bar
                  children: <Widget>[
                    const TabBar(
                      indicatorColor: butterfly,
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(
                          text: "Login",
                        ),
                        Tab(
                          text: "Sign Up",
                        ),
                      ],
                    ),

                    // Options under both login and signup
                    Expanded(
                      child: TabBarView(
                        children: [
                          //////////////////////////////
                          // LOGIN PAGE
                          //////////////////////////////

                          // Login page
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Email entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      _email = value;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(

                                        // Set the user's email
                                        hintText: 'Email'),
                                  ),
                                ),
                                const Text("--- OR ---"),

                                // Phone number entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // Set the user's phone number
                                      _phoneNumber = value;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(
                                        hintText: 'Phone Number'),
                                  ),
                                ),

                                // Put a gap between phone number and password
                                const Text(" "),

                                // Password entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // Set the user's password
                                      _password = value;

                                      _signingup = false;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(
                                        hintText: 'Password'),
                                    obscureText: true,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(140, 0, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Forgot Password?',
                                          style: linkStyle,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) => Container(
                                                  padding:
                                                      const EdgeInsets.all(80),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Enter Your Email Below!",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineLarge),
                                                      Text(""),
                                                      Text(
                                                          "Please check your email for a password reset link"),
                                                      Text(""),
                                                      CustomTextField(
                                                        textField: TextField(
                                                          onChanged: (value) {
                                                            // Set the user's email
                                                            _email = value;
                                                          },
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                          decoration:
                                                              kTextInputDecoration
                                                                  .copyWith(
                                                                      hintText:
                                                                          'Email'),
                                                        ),
                                                      ),
                                                      Text(""),
                                                      Center(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                butterfly, // Set the background color to blue
                                                            minimumSize: const Size(
                                                                100,
                                                                50), // Set the button size (width x height)
                                                          ),
                                                          onPressed:
                                                              resetPassword,
                                                          child: const Text(
                                                            "Send Email",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //////////////////////////////
                          // SIGNUP PAGE
                          //////////////////////////////

                          // Sign up page
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Email entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // Set the user's email
                                      _email = value;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(
                                        hintText: 'Email'),
                                  ),
                                ),

                                // Phone number entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // TODO: MAKE SURE PHONE NUMBER HASN'T BEEN REGISTERED

                                      // Set the user's phone number
                                      _phoneNumber = value;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(
                                        hintText: 'Phone Number'),
                                  ),
                                ),

                                // Password entry text field
                                CustomTextField(
                                  //TODO: MAKE SURE PASSWORD IS CORRECT
                                  textField: TextField(
                                    onChanged: (value) {
                                      // Set the user's password
                                      _password = value;
                                      passwordController.text = value;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(
                                        hintText: 'Password'),
                                    obscureText: true,
                                  ),
                                ),

                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // Set the user's password
                                      _confirmpassword = value;
                                      confirmPasswordController.text = value;
                                      _signingup = true;
                                    },
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: kTextInputDecoration.copyWith(
                                        hintText: 'Re-enter Password'),
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

// LOGIN AS MODERATOR FIELD
          Padding(
            padding: const EdgeInsets.fromLTRB(200, 15, 0, 5),
            child: Row(
              children: [
                RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Login as Moderator',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(50),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Enter Your Moderator Account Information Below",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                    Text(""),
                                    Text(""),
                                    CustomTextField(
                                      textField: TextField(
                                        onChanged: (value) {
                                          // Set the user's email
                                          _email = value;
                                        },
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        decoration: kTextInputDecoration
                                            .copyWith(hintText: 'Email'),
                                      ),
                                    ),
                                    Text(""),
                                    CustomTextField(
                                      textField: TextField(
                                        onChanged: (value) {
                                          // Set the user's email
                                          _password = value;
                                        },
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                        decoration: kTextInputDecoration
                                            .copyWith(hintText: 'Password'),
                                        obscureText: true,
                                      ),
                                    ),
                                    Text(""),
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              butterfly, // Set the background color to blue
                                          minimumSize: const Size(100,
                                              50), // Set the button size (width x height)
                                        ),
                                        onPressed:

                                            //
                                            // TODO: REPLACE WITH OTHER FUNCTION
                                            //
                                            signModIn,
                                        child: const Text(
                                          "Log In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //////////////////

          //////////////////////////////
          // LOGIN BUTTON
          //////////////////////////////

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: butterfly, // Set the background color to blue
                minimumSize:
                    const Size(200, 50), // Set the button size (width x height)
              ),
              onPressed: checkSignUpIn,
              child: const Text(
                "Log In/Sign Up",
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                  fontSize: 18, // Set the text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //////////////////////////////
          // LOGIN WITH GOOGLE BUTTON
          //////////////////////////////

          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
              const Text("Or continue with"),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: SquareTile(
                onTap: () async {
                  AuthService().signInWithGoogle(context);
                },
                imagePath: 'assets/google_logo.png'),
          ),
        ],
      ),
    );
  }
}
