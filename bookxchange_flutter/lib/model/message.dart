import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String recevierId;
  final String message;
  final Timestamp timestamp;
  bool isHearted;
  bool isBrokenHearted;

  Message(
      {required this.senderEmail,
      required this.senderId,
      required this.timestamp,
      required this.recevierId,
      required this.message,
      this.isHearted = false,
      this.isBrokenHearted = false,
      });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': recevierId,
      'message': message,
      'timestamp': timestamp,
      'isHearted': isHearted,
      'isBrokenHearted': isBrokenHearted,
    };
  }
}
