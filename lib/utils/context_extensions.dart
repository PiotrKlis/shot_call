import 'package:flutter/material.dart';

extension AppLocalizationsExtensions on BuildContext {
  void showSuccessfulSnackBar(String text) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), backgroundColor: Colors.green),
      );
  }

  void showFailedSnackBar(String text) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(text), backgroundColor: Colors.red),
      );
  }
}
