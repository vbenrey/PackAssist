import 'package:flutter/material.dart';
import 'startup.dart';
import 'luggage.dart';
import 'travels.dart';

class Testfeatures extends StatelessWidget {
  Testfeatures({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is Beta to test out features first"),
            SizedBox(height: 50,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Luggage()),);
            }, child: Text("Luggage")),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Travels()),);
            }, child: Text("Travels")),
            TextButton(
              child: Text("Return"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
