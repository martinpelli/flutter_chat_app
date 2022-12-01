import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helpers/error_alert.dart';
import 'package:flutter_chat_app/services/auth_service.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Logo(
                  title: 'Register',
                ),
                _Form(),
                Labels(question: 'Do you have an account?', text: 'Login with your account', route: 'login'),
                Text(
                  'Terms and Conditions',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final SocketService socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          iconData: Icons.perm_identity,
          placeholder: 'Name',
          keyboardType: TextInputType.name,
          controller: nameController,
        ),
        CustomInput(
          iconData: Icons.mail_outline,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        CustomInput(
          iconData: Icons.lock_outline,
          placeholder: 'Password',
          keyboardType: TextInputType.text,
          controller: passController,
          isPassword: true,
        ),
        PrimaryButton(
            text: 'register',
            onPressed: authService.isAuthenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final bool isRegistrationOk = await authService.register(nameController.text, emailController.text, passController.text);

                    if (isRegistrationOk) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      showErrorAlert(context, 'Invalid data', 'Your email or password is invalid');
                    }
                  })
      ]),
    );
  }
}
