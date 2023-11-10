import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getOtherUserProfile(String uuid) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8080/user/profile/$uuid'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch other user\'s profile.');
  }
}

Future<String> getOtherUserAboutMe(String uuid) async {
  final Map<String, dynamic> otherUserProfile = await getOtherUserProfile(uuid);
  return otherUserProfile['user_bio'] as String;
}

Future<String> getOtherUserBio(String uuid) async {
  final Map<String, dynamic> otherUserProfile = await getOtherUserProfile(uuid);
  return otherUserProfile['user_bio'] as String;
}

Future<double> getOtherUserCommunityRating(String uuid) async {
  final Map<String, dynamic> otherUserProfile = await getOtherUserProfile(uuid);
  return otherUserProfile['community_rating'] as double;
}
