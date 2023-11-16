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

void unmatchWithUser() {
  //how are we doing this?
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chats'),
      ),
      body: _buildUserList(),
    );
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
        trailing: const IconButton(
          icon: Icon(Icons.delete),
          onPressed: unmatchWithUser,
        ),
      );
    } else {
      return Container();
    }
  }
}

//current user list -- all users except current logged in user
