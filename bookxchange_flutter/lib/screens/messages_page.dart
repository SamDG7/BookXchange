import 'package:bookxchange_flutter/api/other_profile.dart';
import 'package:bookxchange_flutter/screens/chat_page.dart';
import 'package:bookxchange_flutter/screens/other_user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

void unmatchWithUser(String receiverUserID) async {
  print("UNMATCHING");
  print(receiverUserID);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  print(_firebaseAuth.currentUser!.uid);
  //ADD LOGIC TO DELETE CHAT HERE
  //deletes messages and chat room
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection(
            'chat_rooms/${receiverUserID}_${_firebaseAuth.currentUser!.uid}/messages')
        .get();

    if (snapshot.docs.isEmpty) {
      snapshot = await FirebaseFirestore.instance
          .collection(
              'chat_rooms/${_firebaseAuth.currentUser!.uid}_${receiverUserID}/messages')
          .get();
    }
    print(snapshot.docs.length);
    for (DocumentSnapshot ds in snapshot.docs) {
      await ds.reference.delete();

      await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc('${receiverUserID}_${_firebaseAuth.currentUser!.uid}')
          .delete();
    }
  } catch (e) {
    // Handle errors here
    print('Error: $e');
  }

  //THIS IS TEMPORARY AND NEEDS TO BE REMOVED ONCE MATCHING IS DONE
  final receiverUserDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc('${receiverUserID}')
      .delete();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text('Chats'),
              ),
              body: Scrollbar(child: _buildUserList()),
            )));
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        leading: GestureDetector(
          onTap: () {
            // Navigate to user profile
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherUser(
                  userId: data['uid'],
                ),
              ),
            );
          },
          child:
              const Icon(Icons.person), // Add a little icon next to the email
        ),
        onTap: () {
          // Navigate to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ),
            ),
          );
        },
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            unmatchWithUserConfirm(data);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void unmatchWithUserConfirm(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Umatch with User",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Are you sure you want to remove this match",
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success message dialog
                //account is deleted
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                unmatchWithUser(data['uid']);
                Navigator.pop(context); // Close the success message dialog
                //account is deleted
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}



//current user list -- all users except current logged in user
