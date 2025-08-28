import 'package:flutter/material.dart';
import 'startup.dart';
import 'login.dart';
import 'testfeatures.dart';

class Register extends StatelessWidget {
  Register({super.key});
  @override
    Widget build(BuildContext context){
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        backgroundColor: Color.fromARGB(255, 42, 44, 81),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: screenHeight,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/sign-pages.png"),
                        fit: BoxFit.cover
                    ),
                  ),

                  //Top Layer
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, top: 110),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Your\nAccount',
                          style: TextStyle(
                              fontSize: 60,
                              fontFamily: "ITCBenguiat",
                              color: Colors.white
                          ),
                        ),

                        Text(
                          "Create an account so you can\naccess every product.",
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Etna",
                            color: Colors.white,
                          ),
                        ),

                      ], //Children
                    ),

                  ),
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.only(top: 60, left: 15),
              child: IconButton(
                icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 40,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.42),
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 40,
                            fontFamily: "Etna",
                            color: Color.fromRGBO(101, 130, 157, 1)
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(225, 225, 225, 1.0),
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Etna",
                          fontSize: 25,
                        ),
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 20),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(225, 225, 225, 1.0),
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Etna",
                          fontSize: 25,
                        ),
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20, top: 5),
                            suffixIcon: Icon(Icons.visibility_off)
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(225, 225, 225, 1.0),
                          borderRadius: BorderRadius.circular(10)
                      ),

                      child: TextField(
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Etna",
                          fontSize: 25,
                        ),
                        decoration: InputDecoration(
                            hintText: " Confirm Password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20, top: 5),
                            suffixIcon: Icon(Icons.visibility_off)
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: screenWidth,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Testfeatures()),);
                          },
                            child: Text(
                              "Register Now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Etna",
                                fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Etna",
                              fontSize: 20
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),);
                          },
                            child: Text(
                              " Log in",
                              style: TextStyle(
                                  color: Color.fromRGBO(101, 130, 157, 1),
                                  fontFamily: "Etna",
                                  fontSize: 20
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: screenHeight * 0.37,
              right: 45,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color.fromRGBO(35, 41, 52, 1),
                child: Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 70,),
              ),
            ),

          ],
        ),
      );
    }
  }

