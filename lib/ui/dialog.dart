import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';

class SPDialog {
  static void show(
      BuildContext context,
      String title,
      String message
      ) {

    showAlert(
      context: context,
      title: title,
      body: message
    );
  }
}