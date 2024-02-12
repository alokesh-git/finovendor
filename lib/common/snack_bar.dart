import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Notify {
  static void showNotify(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green.shade300,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}