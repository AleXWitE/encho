import 'package:flutter/material.dart';

customSnackBar(String msg) {
  return SnackBar(
      duration: Duration(seconds: 3),
      elevation: 5.0,
      backgroundColor: msg == "correct"
          ? Colors.green
          : msg == "wrong"
              ? Colors.red
              : Colors.black,
      width: 400.0,
      // Width of the SnackBar.
      padding: const EdgeInsets.all(
        16.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Text(
        msg,
        style: TextStyle(
            fontSize: 25.0,
            color: msg == "correct" || msg == "wrong"
                ? Colors.black
                : Colors.grey[400]),
      ));
}
