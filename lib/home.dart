import 'package:flutter/material.dart';
import 'startup.dart';
import 'login.dart';
import 'register.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final headerSize = screenWidth * 0.10;
    final fontSize = screenWidth * 0.05;
    final iconSize = screenHeight * 0.10;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 42, 44, 81),
      body: Center (
        child: Column( //entire thing
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column( //for header and sub header
              children: [
                Icon(Icons.home, size: iconSize + 10, color: Colors.white,),
                Text(
                  "PackAssist",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: headerSize * 1.6,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Smart Travel Packing Assistant",
                  style: TextStyle(
                    fontSize: fontSize * .9,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            SizedBox(height: 120,),

            Column( //for 2 buttons
              children: [
                OutlinedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),);
                  }, //login
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(screenWidth * .65, screenHeight * .055),
                      side: BorderSide(
                        width: 1.3,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize * .9,
                      ),
                    )),

                SizedBox(height: 20,),

                OutlinedButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Register()),);
                }, //register
                    style: OutlinedButton.styleFrom(
                        fixedSize: Size(screenWidth * .65, screenHeight * .055),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          width: 1.3,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Color.fromARGB(255, 42, 44, 81),
                        fontSize: fontSize * .9,
                      ),
                    )),

                SizedBox(height: 20,),

                TextButton( //return
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Startup()),
                    );
                  },
                  child: Text(
                    "Return",
                    style: TextStyle(
                        fontSize: fontSize * .8,
                        color: Color.fromARGB(147, 255, 255, 255)
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

