import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/models/users_response.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';

class UsersService {
  Future<List<User>> getAllUsers() async {
    try {
      final getAllUsersUrl = Uri.parse('${Environment.apiUrl}/users/getAllUsers');

      final response = await http.get(getAllUsersUrl, headers: {'Content-Type': 'application/json', 'x-token': await AuthService.getToken() ?? ''});

      final usersResponse = usersResponseFromMap(response.body);

      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
