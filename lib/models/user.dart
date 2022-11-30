// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
  User({required this.name, required this.email, required this.uid, required this.online});

  final String name;
  final String email;
  final String uid;
  final bool online;

  factory User.fromMap(Map<String, dynamic> json) => User(name: json["name"], email: json["email"], uid: json["uid"], online: json["online"]);

  Map<String, dynamic> toMap() => {"name": name, "email": email, "uid": uid, "online": online};
}
