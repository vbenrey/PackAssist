import 'package:flutter/material.dart';
import 'startup.dart';

class Luggage extends StatelessWidget {
  Luggage({super.key});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final headerSize = screenWidth * 0.10;
    final fontSize = screenWidth * 0.10;
    final iconSize = screenHeight * 0.10;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
        children: [
          AppBar( //app bar duh
            toolbarHeight: screenHeight * .08,
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 42, 44, 81),
            leading: Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
              ),

            ),
            title: Text(
                "Luggage",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 30,
            ),
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.menu),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * .9,
                  height: screenHeight * .15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                      spreadRadius: 3,
                    ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(Icons.airplanemode_active_rounded, color: Colors.blue, size: iconSize * .5),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //REMINDER PLS THIS IS WHAT ALIGN TEXTS TO LEFT BRO NAKAKAIYAK BRO
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Text(
                                  "Tokyo, Japan",
                                  style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerSize * .6
                              )
                            ),
                            Text(
                                "September 15 - September 22, 2025",
                                style: TextStyle(
                                  fontSize: fontSize * .35
                                )
                            )
                          ],
                        ),
                        ),
                      ],
                  ),
                ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Items Packed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: headerSize * .5,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * .9,
                  height: screenHeight * .30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                      spreadRadius: 3,
                    ),
                    ],
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row( //category
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.account_balance, size: iconSize * .3, color: Colors.blue),
                                  Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "Clothing",
                                        style: TextStyle(
                                            fontSize: headerSize * .45,
                                            fontWeight: FontWeight.bold
                                        ),
                                      )
                                  ),
                                ],
                              ),
                                  Text("5 Items",
                                  style: TextStyle(
                                      fontSize: headerSize * .45,
                                      fontWeight: FontWeight.bold,
                                  ),)
                            ],
                          ),
                          SizedBox(height: 13),
                          DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: fontSize * .45,
                                  color: Colors.black
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row( //item 1
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "T-shirts",
                                          ),
                                          Text(
                                              "4x"
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 13),
                                      Row( //item 2
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Jeans"
                                          ),
                                          Text(
                                              "2x"
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 13),
                                      Row( // item 3
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Underwear"
                                          ),
                                          Text(
                                              "7x"
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 13),
                                      Row( // item 4
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Socks"
                                          ),
                                          Text(
                                              "6x"
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 13),
                                      Row( // item 4
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Hats"
                                          ),
                                          Text(
                                              "1x"
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                          ),
                        ],
                      ),
                  ),
                ),

                //2nd category
                SizedBox(height: 30,),

                Container(
                  width: screenWidth * .9,
                  height: screenHeight * .30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                      spreadRadius: 3,
                    ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row( //category
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.account_balance, size: iconSize * .3, color: Colors.blue),
                                Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "Electronics",
                                      style: TextStyle(
                                          fontSize: headerSize * .45,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                ),
                              ],
                            ),
                            Text("5 Items",
                              style: TextStyle(
                                fontSize: headerSize * .45,
                                fontWeight: FontWeight.bold,
                              ),)
                          ],
                        ),
                        SizedBox(height: 13),
                        DefaultTextStyle(
                          style: TextStyle(
                              fontSize: fontSize * .45,
                              color: Colors.black
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row( //item 1
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Phone Charger",
                                      ),
                                      Text(
                                          "1x"
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13),
                                  Row( //item 2
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Camera"
                                      ),
                                      Text(
                                          "1x"
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13),
                                  Row( // item 3
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Headphones"
                                      ),
                                      Text(
                                          "1x"
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13),
                                  Row( // item 4
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Laptop"
                                      ),
                                      Text(
                                          "1x"
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13),
                                  Row( // item 4
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "Hats"
                                      ),
                                      Text(
                                          "1x"
                                      ),
                                    ],
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        ),
      ),
    );
  }
}
