import 'dart:convert';

import 'user.dart';

AuthResponse authResponseFromMap(String str) => AuthResponse.fromMap(json.decode(str));

String authResponseToMap(AuthResponse data) => json.encode(data.toMap());

class AuthResponse {
  AuthResponse({
    required this.ok,
    required this.user,
    required this.token,
  });

  final bool ok;
  final User user;
  final String token;

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        ok: json["ok"],
        user: User.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "ok": ok,
        "user": user.toMap(),
        "token": token,
      };
}
