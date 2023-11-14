import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookxchange_flutter/components/chat_bubble.dart';
import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage(
      {super.key,
      required this.receiverUserID,
      required this.receiverUserEmail});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String _subject = "";
  late String _msg = "";

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverUserEmail,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
        backgroundColor: butterfly,
        actions: <Widget>[
          PopupMenuButton(
              icon: const Icon(
                Icons.more,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Report this user'),
                      onTap: () {
                        reportUser(context);
                      },
                    )
                  ])
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _firebaseAuth.currentUser!.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        }));
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              mainAxisAlignment:
                  (data['senderId'] == _firebaseAuth.currentUser!.uid)
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                Text(data['senderEmail']),
                ChatBubble(message: data['message']),
              ],
            )));
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: TextField(
          controller: _messageController,
          obscureText: false,
          decoration: const InputDecoration(hintText: 'Type Message Here'),
        )),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(
            Icons.arrow_upward,
            size: 40,
          ),
        )
      ],
    );
  }

  void reportUser(context) {
    //report user
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
            padding: const EdgeInsets.all(80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Report User: \n" + widget.receiverUserEmail,
                    style: Theme.of(context).textTheme.headlineMedium),
                const Text(""),
                const Text("Please enter a subject for your report"),
                const Text(""),
                CustomTextField(
                  textField: TextField(
                    onChanged: (value) {
                      // Set the user's email
                      _subject = value;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    decoration:
                        kTextInputDecoration.copyWith(hintText: 'Subject'),
                  ),
                ),
                const Text(""),
                const Text(""),
                const Text("Please provide the specifics of your report below"),
                const Text(""),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 50,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 2.5,
                      color: butterfly,
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      // Set the user's email
                      _msg = value;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    decoration:
                        kTextInputDecoration.copyWith(hintText: 'Comments'),
                  ),
                ),
                const Text(""),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          butterfly, // Set the background color to blue
                      minimumSize: const Size(
                          100, 50), // Set the button size (width x height)
                    ),
                    onPressed: () {
                      sendUserReport(widget.receiverUserEmail);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Submit Report",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  Future sendUserReport(String reportName) async {
    //send email to mods
    print('attempting to send user report');
    print(reportName);
    const email = 'bookxchangehelp@gmail.com';
    const serviceId = 'service_7syjpzx';
    const templateId = 'template_eium6e8';
    const userId = 'VYsR9kMs96Fm7r3Ne';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'report_name': reportName,
          'from_name': FirebaseAuth.instance.currentUser!.email,
          'user_email': FirebaseAuth.instance.currentUser!.email,
          'user_subject': _subject,
          'user_message': _msg,
        }
      }),
    );
    print(response.body);
  }
}
