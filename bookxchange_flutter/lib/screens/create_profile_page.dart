import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/screens/login_signup_screen.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:bookxchange_flutter/globals.dart';


class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}


  class _MultiSelectState extends State<MultiSelect> {
    final List<String> _preferredGenres = [];

    void _itemChange(String genre, bool isSelected) {
      setState(() {
        if (isSelected) {
          _preferredGenres.add(genre);
        } else {
          _preferredGenres.remove(genre);
        }
      });
    }

    void _cancel() {
      Navigator.pop(context);
    }

    void _submit() {
      Navigator.pop(context, _preferredGenres);
    }

   @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Select Genres',
        style: TextStyle(
          color: butterfly,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          //tileColor: isSelected ? Colors.blue : null, 
          children: widget.items
              .map((item) => CheckboxListTile.adaptive(
                    value: _preferredGenres.contains(item),
                    selectedTileColor: butterfly,
                    title: Text(
                      item,
                      style: TextStyle(
                        //color: white,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}



class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late String userName = "";
  late String userBio;
  List<String> _preferredGenres = [];
  Future<CreateProfile>? _newProfile;

  void _showMultiSelect() async {

    final List<String> items = [
      'Genre 1',
      'Genre 2',
      'Genre 3',
      'Genre 4',
      'Genre 5',
      'Genre 6',
      'Genre 7',
      'Genre 8',
      'Genre 9',
      'Genre 10',
      'Genre 11',
      'Genre 12',
    ];
    
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      } 
    );

    if (results != null) {
        setState(() {
          _preferredGenres = results;
        });
    }
  }

  bool checkNullValue() {
    if (userName.isEmpty) {
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Create Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Vertical scrollable layout
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                child: Container(
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: butterfly,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(
                          'assets/profile_pic_elena.png'), // TODO: REPLACE WITH USER IMAGE
                    ),
                  ),
                ),
              ),

              // Change profile picture buttons
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // OPEN CAMERA
                      },
                      icon: Icon(
                        Icons.photo_camera,
                        color: butterfly,
                      ),
                      label: Text(
                        'Open Camera',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 2.0, color: butterfly),
                      ),
                    ),
                  ),
                  // TODO: PUT CAMERA ROLL BUTTON HERE W SAME PADDING
                ],  
              ),

              // TODO: PUT EDITABLE NAME, BIO, ECT HERE

              
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 50, 40, 10),
            child:
          CustomTextField2(
            textField: TextField(
              onChanged: (value) {  
                userName = value;
              },
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: kTextInputDecoration.copyWith(
                  // Set the user's name
                  hintText: 'Name',
                  //contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0)
                  ),

            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
            child :SizedBox(
              width: 240, // <-- TextField width
              height: 110,
            child:
          CustomTextField2(
            textField: TextField(
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {  
                userBio = value;
              },
              style: const TextStyle(
                fontSize: 15,
              ),
              decoration: kTextInputDecoration.copyWith(
                  // Set the user's name
                  hintText: 'Bio',
                  //contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0)
                  ),

            ),
          ),
          ),
          ), 
          Padding(
          padding: const EdgeInsets.fromLTRB(80, 20, 80, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // use this button to open the multi-select dialog
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: butterfly,
                ),
                onPressed: _showMultiSelect,
                child: const Text(
                  "Select your genres",
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                    fontSize: 18, // Set the text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                const Divider(
                  height: 20,
                ),
              // display selected items
              Wrap(
                children: _preferredGenres
                    .map((e) => Chip(
                          label: Text(
                            e,
                          style: TextStyle(
                            color: butterfly, // Set the text color to white
                            fontSize: 14, // Set the text size
                          ),
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
          ),

          Padding(
            //TODO: MAKE BUTTON SWITCH TO A SIGN UP BUTTON WHEN ON THE SIGN UP TAB

            padding: const EdgeInsets.fromLTRB(100, 20, 100, 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: butterfly, // Set the background color to blue
                minimumSize:
                    const Size(200, 50), // Set the button size (width x height)
              ),
              onPressed: () {
                if (checkNullValue() == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: Container(
                          padding: const EdgeInsets.all(19),
                          height: 80, 
                          decoration: const BoxDecoration(
                            color: butterfly,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: const Text(
                            "Make sure to enter your name and bio!",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            )
                          )
                        ),
                    ),
                  );
                } else {
                  _newProfile = createUserProfile(getUUID(), userName, userBio, _preferredGenres);
                Navigator.push(
                   context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                }
              },
              child: const Text(
                "Create Profile",
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                  fontSize: 18, // Set the text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
