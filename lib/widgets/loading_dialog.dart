import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
            child: const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            onWillPop: () async {
              return false;
            });
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
