import 'package:flutter/material.dart';
import 'home.dart';

class Startup extends StatelessWidget {
  Startup({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final headerSize = screenWidth * 0.10;
    final fontSize = screenWidth * 0.10;
    final iconSize = screenHeight * 0.10;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 42, 44, 81),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // for logo and header
              children: [
              Icon(Icons.home, size: iconSize + 10, color: Colors.white,),
              Text(
                "PackAssist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: headerSize + 8,
                  color: Colors.white,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Proceed",
                    style: TextStyle(
                        fontSize: fontSize - 20,
                        color: Color.fromARGB(147, 255, 255, 255)
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

