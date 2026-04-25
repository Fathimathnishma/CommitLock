import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    if (message.trim().isEmpty) return;

    final theme = Theme.of(context);

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError
          ? theme.colorScheme.error
          : theme.colorScheme.primary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
