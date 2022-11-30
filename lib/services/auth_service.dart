import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/global/environment.dart';
import 'package:flutter_chat_app/models/auth_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? user;
  bool _isAuthenticating = false;

  bool get isAuthenticating => _isAuthenticating;

  set isAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isAuthenticating = true;
    final data = {'email': email, 'password': password};
    final loginUrl = Uri.parse('${Environment.apiUrl}/login');

    final response = await http.post(loginUrl, body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    isAuthenticating = false;

    if (response.statusCode == 200) {
      final loginResponse = authResponseFromMap(response.body);
      user = loginResponse.user;

      await saveJWTInStorage(loginResponse.token);

      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    isAuthenticating = true;
    final data = {'name': name, 'email': email, 'password': password};
    final registerUrl = Uri.parse('${Environment.apiUrl}/login/createUser');

    final response = await http.post(registerUrl, body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    isAuthenticating = false;

    if (response.statusCode == 200) {
      final registerResponse = authResponseFromMap(response.body);
      user = registerResponse.user;

      await saveJWTInStorage(registerResponse.token);

      return true;
    }
    return false;
  }

  Future<bool> isLoggedIn() async {
    final String? token = await getToken();

    final registerUrl = Uri.parse('${Environment.apiUrl}/login/renewToken');

    final response = await http.get(registerUrl, headers: {'Content-Type': 'application/json', 'x-token': token!});

    if (response.statusCode == 200) {
      final renewTokenresponse = authResponseFromMap(response.body);
      user = renewTokenresponse.user;

      await saveJWTInStorage(renewTokenresponse.token);

      return true;
    }

    await deleteJWTInStorage();
    return false;
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    return token;
  }

  Future saveJWTInStorage(String token) async {
    const storage = FlutterSecureStorage();
    return await storage.write(key: 'token', value: token);
  }

  Future deleteJWTInStorage() async {
    const storage = FlutterSecureStorage();
    return await storage.delete(key: 'token');
  }
}
