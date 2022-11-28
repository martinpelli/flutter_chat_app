import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String question;
  final String text;

  const Labels({Key? key, required this.route, required this.question, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(question, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300)),
      const SizedBox(height: 10),
      GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, route),
          child: Text(text, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold)))
    ]);
  }
}
