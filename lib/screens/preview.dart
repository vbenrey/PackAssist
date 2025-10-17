import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:packassist/screens/colors.dart';

class PreviewPage extends StatelessWidget{

  PreviewPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: whitish,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.53,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)),

                      image: DecorationImage(
                        image: AssetImage('assets/images/suit3.jpg'),
                        fit: BoxFit.cover,
                      )
                  ),
                ),

                Positioned(
                    right: 45,
                    left: 20,
                    top: 70,
                    child: Text(
                      "Less\nstress,\nmore\nadventure",
                      style: TextStyle(
                        fontFamily: 'Yeseva',
                        fontSize: 60,
                        color: whitish,
                      ),
                    ),
                )
              ],
            ),

            SizedBox(height: 20),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.start,
                    "PackAssist",
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'Crimson',
                        fontWeight: FontWeight.bold,
                        color: sagegreen
                    ),
                  ),

                  SizedBox(height: 30),

                  Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: Text(
                        textAlign: TextAlign.justify,
                        "Pack smart. Travel light. Let us handle the list, you chase the adventure.",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Crimson',
                            fontWeight: FontWeight.bold,
                            color: black
                        )
                    ),
                  ),

                  SizedBox(height: 40),

                  SlideAction(
                    key: UniqueKey(),
                    onSubmit: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    text: "Get Started",
                    textStyle: TextStyle(
                      fontFamily: 'Alice',
                      fontWeight: FontWeight.bold,
                      color: sand,
                      fontSize: 20
                    ),
                    sliderButtonIcon: Icon(Icons.chevron_right_rounded, color: sage, fontWeight: FontWeight.bold,),

                    elevation: 0,
                    innerColor: creamwhite,
                    outerColor: black,
                    borderRadius: 10,
                  ),

                  TextButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        overlayColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 17,
                              color: black,
                              fontFamily: 'Crimson',
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 5),

                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 17,
                              color: grayblue,
                              fontFamily: 'Crimson',
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )
                  )
                ],
              )
        )
          ],
        ),
      )
    );
  }
}