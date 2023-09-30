// Import packages from different files in the bookxchange_flutter directory
import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/components/square_tile.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';

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
  bool _saving = false;

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
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                    TabBar(
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
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
                                Text("--- OR ---"),

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
                                Text(" "),

                                // Password entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // Set the user's password
                                      _password = value;
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Email entry text field
                                CustomTextField(
                                  textField: TextField(
                                    onChanged: (value) {
                                      // TODO: MAKE SURE EMAIL HASN'T BEEN REGISTERED

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
                                  // TODO: MAKE SURE PASSWORDS MATCH
                                  textField: TextField(
                                    // TODO: SHOULD BE ON PASSWORD CONFIRMATION, NOT ONCHANGED
                                    onChanged: (value) {
                                      // Set the user's password
                                      _password = value;
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

            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: butterfly, // Set the background color to blue
                minimumSize:
                    Size(200, 50), // Set the button size (width x height)
              ),
              onPressed: () {
                // Add your button's onPressed logic here
              },
              child: Text(
                "Log In",
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
              Text("Or continue with"),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: SquareTile(
                onTap: () {
                  //ADD ACTUAL GOOGLE LOGIN STUFF
                },
                imagePath: 'assets/google_logo.png'),
          ),
        ],
      ),
    );
  }
}
