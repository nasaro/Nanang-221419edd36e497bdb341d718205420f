import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

// method defined to check internet connectivity

void toastToForm(String parStr) {
  Fluttertoast.showToast(
      msg: parStr,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}




