import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/login_screen.dart';
import 'package:flutter_chat_app/screens/users_screen.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: checkLoginState(context), builder: ((context, snapshot) => Text('Hola Mundo'))),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);

    final bool isAuthenticated = await authService.isLoggedIn();

    if (isAuthenticated) {
      socketService.connect();
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => UsersScreen(), transitionDuration: Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_, __, ___) => LoginScreen(), transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
