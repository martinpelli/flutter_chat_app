import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showErrorAlert(BuildContext context, String title, String message) {
  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                MaterialButton(
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'),
                )
              ],
            ));
    return;
  }

  showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [CupertinoDialogAction(isDefaultAction: true, onPressed: () => Navigator.pop(context), child: const Text('Ok'))]));
}
