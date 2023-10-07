// Import packages from different files in the bookxchange_flutter directory
// import 'dart:js_interop';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/components/square_tile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

// Stateful Widget
class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});
  static String id = 'login_signup_screen';

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

// Login Signup Screens process
class _LoginSignupScreenState extends State<LoginSignupScreen> {
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

  void signUserUp() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );

    if (checkForValidPass() && _password == _confirmpassword) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);

        // Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Navigator.pop(context);

        //WRONG LOGIN CREDENTIALS
        if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          wrongEmailMessage();
          print('WRONG Something');
        }
      }
    } else {
      // Navigator.pop(context);
      if (checkForValidPass() == false) {
        badPassword();
      } else {
        passwordsNoMatch();
      }
    }
    //try sign up
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
    //create loading circle while signing in
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );

    //try sign in
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      // Login/Signup page is divided into a column with different containers stacked vertically
      body: Column(
        children: [
          // Display logo above login/sign up bar options
          SizedBox(
            height: 175,
            child: Image.asset('assets/logo_with_text.png'),
          ),

          // Pad the container holding the login/sign up options
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height - 540,

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

                                const SizedBox(height: 30),
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
                                // SizedBox(
                                //   height: 20,
                                // ),
                                // Row(
                                //   children: [
                                //     AnimatedContainer(
                                //       duration: Duration(milliseconds: 500),
                                //       width: 20,
                                //       height: 20,
                                //       decoration: BoxDecoration(
                                //           border: Border.all(color: butterfly),
                                //           borderRadius:
                                //               BorderRadius.circular(50)),
                                //       child: Center(
                                //         child: Icon(
                                //           Icons.check,
                                //           color: Colors.white,
                                //           size: 15,
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 10,
                                //     ),
                                //     Text("Contains at least 8 Characters")
                                //   ],
                                // ),
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

          //////////////////////////////
          // LOGIN BUTTON
          //////////////////////////////

          Padding(
            //TODO: MAKE BUTTON SWITCH TO A SIGN UP BUTTON WHEN ON THE SIGN UP TAB

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
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: SquareTile(
                onTap: () => AuthService().signInWithGoogle(),
                imagePath: 'assets/google_logo.png'),
          ),
        ],
      ),
    );
  }
}
