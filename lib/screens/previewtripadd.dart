import 'package:flutter/material.dart';
import 'package:packassist/screens/colors.dart';


class AddTripPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Opacity(
                  opacity: 0.8,
                  child: Image(
                    image: AssetImage('assets/images/airplane.jpg'),
                    fit: BoxFit.cover,
                  ),
                )
            ),

            Center(
              child: Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.58),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.37,
                decoration: BoxDecoration(
                  color: whitish,
                  borderRadius: BorderRadius.all(Radius.circular(40))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                        "Trips are fun. Packing shouldn't be a puzzle.",
                      style: TextStyle(
                        fontFamily: 'Crimson',
                        fontWeight: FontWeight.bold,
                        color: black,
                        fontSize: 25
                      ),
                    ),

                    SizedBox(height: 30),

                    Text(
                      textAlign: TextAlign.center,
                      "We'll help you remember everything, from socks to sunscreen.",
                      style: TextStyle(
                          fontFamily: 'Crimson',
                          fontWeight: FontWeight.bold,
                          color: grayblue,
                          fontSize: 15
                      ),
                    ),

                    SizedBox(height: 50),

                    ElevatedButton(
                        onPressed: (){Navigator.pushNamed(context, '/trip');},
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: black,
                            overlayColor: grayblue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(40))
                            )
                        ),
                        child: Text(
                          "Start Trip",
                          style: TextStyle(
                              fontSize: 20,
                              color: creamwhite,
                              fontFamily: 'Alice',
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 50, left: 20),
              child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.chevron_left_rounded, size: 40, color: whitish,)
              ),
            )
          ],
        ),
      )
    );
  }
}