import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData iconData;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isPassword;

  const CustomInput(
      {Key? key, required this.iconData, required this.placeholder, required this.controller, this.keyboardType, this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 5), blurRadius: 5)]),
      child: TextField(
        controller: controller,
        autocorrect: false,
        keyboardType: keyboardType ?? TextInputType.none,
        obscureText: isPassword,
        decoration: InputDecoration(prefixIcon: Icon(iconData), focusedBorder: InputBorder.none, border: InputBorder.none, hintText: placeholder),
      ),
    );
  }
}
