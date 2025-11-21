import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static Future<bool> message(String message) async {
    return await Fluttertoast.showToast(
          msg: message,
          // The message to display
          toastLength: Toast.LENGTH_SHORT,
          // Duration of the toast (short or long)

          // Position of the toast (top, center, bottom)
          timeInSecForIosWeb: 1,
          // Duration for iOS and web
          backgroundColor: Colors.black,

          // Background color of the toast
          textColor: Colors.white,
          // Text color of the message
        ) ??
        true;
  }

  static Future<bool> error(String message) async {
    return await Fluttertoast.showToast(
          msg: message,
          // The message to display
          toastLength: Toast.LENGTH_SHORT,
          // Duration of the toast (short or long)

          // Position of the toast (top, center, bottom)
          timeInSecForIosWeb: 1,
          // Duration for iOS and web
          backgroundColor: Colors.redAccent,

          // Background color of the toast
          textColor: Colors.white,
          // Text color of the message
        ) ??
        true;
  }
}
