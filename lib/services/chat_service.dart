import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/messages_response.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';

class ChatService with ChangeNotifier {
  User? receptorUser;

  Future<List<Message>> getMessagesFromChat(String userId) async {
    final messagesfromChatUrl = Uri.parse('${Environment.apiUrl}/messages/$userId');

    final response =
        await http.get(messagesfromChatUrl, headers: {'Content-Type': 'application/json', 'x-token': await AuthService.getToken() ?? ''});

    final messagesResponse = messagesResponseFromMap(response.body);

    return messagesResponse.messages;
  }
}
