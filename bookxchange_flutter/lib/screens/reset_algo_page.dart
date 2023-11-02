import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:bookxchange_flutter/screens/home_page.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';

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
          fontWeight: FontWeight.bold,
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

class ResetAlgoScreen extends StatefulWidget {
  const ResetAlgoScreen({super.key});

  @override
  State<ResetAlgoScreen> createState() => _ResetAlgoScreenState();
}

class _ResetAlgoScreenState extends State<ResetAlgoScreen> {
  late String userName = "";
  late String userBio;
  late String userZipCode;
  late String userRadius;
  List<String> _preferredGenres = [];
  //Future<CreateProfile>? _newProfile;

  void _showMultiSelect() async {
    final List<String> items = [
      'Crime and Mystery',
      'Fantasy',
      'Historical',
      'Horror',
      'Romance',
      'Science Fiction',
      'Thriller',
      'Young-adult',
      'New-adult',
      'Biography',
      'Paranormal',
      'Classics',
      'Adventure',
      'Fairy Tale',
      'Mythology',
      'Fiction'
    ];

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(items: items);
        });

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
    if (userZipCode.isEmpty) {
      return false;
    }
    if (userRadius.isEmpty) {
      return false;
    }
    return true;
  }

  /*
  bool checkNegative {
    if (userRadius.isNegative)
    return false;
    }
    return true;
  }*/

  void _negativeradius() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Radius cannot be negative!'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: butterfly,
        title: Text(
          'Reset Personal Feed',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Vertical scrollable layout
      body: ListView(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(60, 50, 50, 0),
                //child: Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //child: _showMultiSelect
                  children: [
                    //use this button to open the multi-select dialog
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
                                    color:
                                        butterfly, // Set the text color to white
                                    fontSize: 14, // Set the text size
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),

              SizedBox(height: 50),
              //),
            ],
          ),
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(150, 0, 0, 0),
                child: ElevatedButton(
                  //TRIGGER SAVE POPUP AND EXIT
                  onPressed: () async {
                    if (_preferredGenres.isEmpty) {
                      //ADD POPUP
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Make sure to pick some genres!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      resetUserAlgo(getUUID(), _preferredGenres);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: butterfly,
                          content: Center(
                            child: Text('Your changes have been saved!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500)),
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                      Future.delayed(Duration(seconds: 2), () {
                        //Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: butterfly,
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
