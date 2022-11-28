import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const PrimaryButton({Key? key, required this.onPressed, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(2),
            shape: MaterialStateProperty.all(const StadiumBorder()),
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          )),
        ));
  }
}
