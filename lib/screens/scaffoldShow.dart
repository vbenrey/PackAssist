import 'package:flutter/material.dart';
import 'package:packassist/screens/colors.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:
      Text(
        textAlign: TextAlign.center,
        "$message",
        style: TextStyle(
          fontFamily: 'Alice',
          fontWeight: FontWeight.bold,
          color: creamwhite,
        ),
      ),
        backgroundColor: black,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
        ),

        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      )
  );
}