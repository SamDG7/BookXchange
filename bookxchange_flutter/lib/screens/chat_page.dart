import 'dart:convert';
import 'package:bookxchange_flutter/api/user_account.dart';
import 'package:bookxchange_flutter/api/user_profile.dart';
import 'package:bookxchange_flutter/globals.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:bookxchange_flutter/components/chat_bubble.dart';
import 'package:bookxchange_flutter/components/components.dart';
import 'package:bookxchange_flutter/constants.dart';
import 'package:bookxchange_flutter/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Color iconColor = Colors.grey;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String _subject = "";
  late String _msg = "";
  Future<BlockedUsers>? _addBlockedUser;

  final String del = "Delivered.";
  final String sending = "Sending...";
  bool sent = false;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      sent = true;
      _messageController.clear();
    }
  }

  Future<String> sendDefaultMessage() async {
    String chatroomId =
        "${widget.receiverUserID}_${_firebaseAuth.currentUser!.uid}";

    try {
      // Get the cities of the other user
      UserCities receiverCities = await getCities(widget.receiverUserID);
      UserCities senderCities = await getCities(_firebaseAuth.currentUser!.uid);

      List<String> cities = [];

      if (receiverCities.cities != null) {
        cities.addAll(receiverCities.cities.map((city) => city.toString()));
      }

      if (senderCities.cities != null) {
        cities.addAll(senderCities.cities.map((city) => city.toString()));
      }

      String messageContent =
          'Hi, let\'s meet up! A suggested nearby location is a public library in any of the following cities: ${cities.join(', ')}';

      return messageContent;

      // Send the message to the other user
      //await _chatService.sendMessage(widget.receiverUserID, messageContent);
    } catch (error) {
      // Handle errors (e.g., user not found)
      print('Error fetching user cities: $error');
      return '';
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
                    ),
                    PopupMenuItem(
                      child: const Text('Block User'),
                      onTap: () {
                        blockUserConfirmationPopup(context);
                      },
                    ),
                  ])
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                //border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<String>(
                future: sendDefaultMessage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black, // Set to your desired text color
                        ),
                        children: [
                          TextSpan(
                            text:
                                'You’ve matched with ${widget.receiverUserEmail}!\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          WidgetSpan(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      25.0), // Adjust the bottom padding as needed
                            ),
                          ),
                          TextSpan(
                            text: snapshot.data,
                            
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
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

    if (data['message'].startsWith('Hi, let\'s meet up!')) {
      return Container(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: ChatBubble(message: data['message']),
                        ),
                      ),
                    ],
                  ),
                ],
              )));
    } else {
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
                  Row(
                    crossAxisAlignment:
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    mainAxisAlignment:
                        (data['senderId'] == _firebaseAuth.currentUser!.uid)
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          data['isHearted']
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                        iconSize: 25,
                        color: data['isHearted'] ? Colors.red : Colors.grey,
                        onPressed: () {
                          toggleHeart(document.reference, !data['isHearted']);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          data['isBrokenHearted']
                              ? Icons.heart_broken
                              : Icons.heart_broken_outlined,
                        ),
                        iconSize: 25,
                        color:
                            data['isBrokenHearted'] ? Colors.red : Colors.grey,
                        onPressed: () {
                          toggleBrokenHeart(
                              document.reference, !data['isBrokenHearted']);
                        },
                      ),
                      ChatBubble(message: data['message']),
                    ],
                  ),
                  const Text("Delivered"),
                ],
              )));
    }
  }

  void toggleHeart(DocumentReference reference, bool newHeartStatus) {
    reference.update({'isHearted': newHeartStatus});
  }

  void toggleBrokenHeart(DocumentReference reference, bool newHeartStatus) {
    reference.update({'isBrokenHearted': newHeartStatus});
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.only(
          bottom: 25.0, left: 20), // Adjust the bottom padding as needed
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              obscureText: false,
              decoration: const InputDecoration(hintText: 'Type Message Here'),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            ),
          ),
        ],
      ),
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
                      reportUserConfirmPopup();
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

  void reportUserConfirmPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "User Report",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Your report has been succesfully submitted.",
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        "/")); // Close the success message dialog
                //account is deleted
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void successfullyBlockedUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Blocked User'),
          content: Text('You have successfully blocked this user!',
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () async {
                //ADD LOGIC TO DELETE CHAT HERE
                //deletes messages and chat room
                try {
                  var snapshot = await FirebaseFirestore.instance
                      .collection(
                          'chat_rooms/${widget.receiverUserID}_${_firebaseAuth.currentUser!.uid}/messages')
                      .get();
                  if (mounted) {
                    for (DocumentSnapshot ds in snapshot.docs) {
                      await ds.reference.delete();
                    }

                    await FirebaseFirestore.instance
                        .collection('chat_rooms')
                        .doc(
                            '${widget.receiverUserID}_${_firebaseAuth.currentUser!.uid}')
                        .delete();
                  }
                } catch (e) {
                  // Handle errors here
                  print('Error: $e');
                }

                //deletes user doc so chat doesn't show up on page

                //THIS IS TEMPORARY AND NEEDS TO BE REMOVED ONCE MATCHING IS DONE
                final receiverUserDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc('${widget.receiverUserID}')
                    .delete();

                //STORE BLOCKED ID FOR BLOCKEE
                _addBlockedUser = addUBlockedUser(
                    _firebaseAuth.currentUser!.uid, widget.receiverUserID);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void blockUserConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Blocking of User",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text("Are you sure you want to block this user?",
              style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                successfullyBlockedUser(context);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }
}
