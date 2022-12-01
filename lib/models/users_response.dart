import 'dart:convert';

import 'package:flutter_chat_app/models/user.dart';

UsersResponse usersResponseFromMap(String str) => UsersResponse.fromMap(json.decode(str));

String usersResponseToMap(UsersResponse data) => json.encode(data.toMap());

class UsersResponse {
  UsersResponse({
    required this.ok,
    required this.users,
  });

  final bool ok;
  final List<User> users;

  factory UsersResponse.fromMap(Map<String, dynamic> json) => UsersResponse(
        ok: json["ok"],
        users: List<User>.from(json["users"].map((x) => User.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "users": List<dynamic>.from(users.map((x) => x.toMap())),
      };
}
