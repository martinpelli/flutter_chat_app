import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/custom_input.dart';
import 'package:flutter_chat_app/widgets/primary_button.dart';

import '../widgets/labels.dart';
import '../widgets/logo.dart';

class LoginScreen extends StatelessWidget {
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
                Logo(title: 'Messenger'),
                _Form(),
                Labels(question: "Don't have account?", text: 'Create account', route: 'register'),
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
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
          iconData: Icons.mail_outline,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        CustomInput(
          iconData: Icons.lock_outline,
          placeholder: 'Password',
          controller: passController,
          isPassword: true,
        ),
        PrimaryButton(text: 'login', onPressed: () {})
      ]),
    );
  }
}
