import 'package:flutter/material.dart';

class Helper {

  static void goPage({required BuildContext context,required Widget page}){
    Navigator.push(context, MaterialPageRoute(builder:(context) => page,));
  }
}

