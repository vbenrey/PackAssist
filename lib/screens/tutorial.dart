import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/colors.dart';

class Tutorial extends StatelessWidget {
  Tutorial({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, size: 40, color: black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text("FAQ List",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Crimson",
                color: black
            )),
        backgroundColor: whitish,
        iconTheme: IconThemeData(
            size: 40,
            color: black
        ),
      ),
      drawer: Drawer(
        backgroundColor: black,
        child: Padding(
          padding: EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.menu_rounded, size: 50, color: sand,)),
                      SizedBox(height: 10),
                      Text("PackAssist",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold,
                            fontFamily: "Crimson", color: sand
                        ),),
                      SizedBox(height: 30),
                      Divider(
                        height: 4,
                        color: sand,
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/home');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  Home",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/travel');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  Check Travels",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/profile');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  User Profile",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: ()
                        {Navigator.pushNamed(context, '/about');},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("  About Us",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold,
                                  fontFamily: "Crimson", color: sand
                              ),),
                            Icon(Icons.arrow_forward_ios_rounded, size: 20, color: sand, fontWeight: FontWeight.bold,)
                          ],
                        ),
                      ),
                      SizedBox(height: 130),
                    ],
                  ),),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(onPressed: () {
                    //for signing out
                    Supabase.instance.client.auth.signOut();
                    Supabase.instance.client.auth.refreshSession();
                    Navigator.pushNamedAndRemoveUntil(context, '/preview', (route) => false);
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sand,
                      minimumSize: Size(MediaQuery.widthOf(context), 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Log Out",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Crimson",
                          color: black,
                          fontSize: 25
                      ),),
                  ),),
                //Expanded(child: SizedBox(height: 50,)),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            children: [
              // SizedBox(height: 150),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whitish,
                    boxShadow: [BoxShadow(
                        offset: Offset(1, 5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Color.fromRGBO(0, 0, 0, 0.1)
                    )],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text("How to view my trips?",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("You can view your trips by pressing the following:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 10),
                    Text("- View Travel Log found in the home page\n- Check Travels in the menu bar\n- My Trips in the user profile page",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whitish,
                    boxShadow: [BoxShadow(
                        offset: Offset(1, 5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Color.fromRGBO(0, 0, 0, 0.1)
                    )],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text("How can I check the weather?",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("You can check the weather by the following:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 10),
                    Text("- Searching the city's name in the home page\n- Navigating to the View Weather Forecast in the home page for more detailed forecasts",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whitish,
                    boxShadow: [BoxShadow(
                        offset: Offset(1, 5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Color.fromRGBO(0, 0, 0, 0.1)
                    )],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text("How can I start packing?",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("You can start packing by navigating to the following:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 10),
                    Text("- To pack for a new trip, navigate to the Add a Trip button on our home page, fill out the form, and finalize your travel. Afterwards, you can start packing.\n- To pack for an existing trip, Navigate to View Travel Log and locate your trip, and press the ADD button inside it, then you can start packing.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whitish,
                    boxShadow: [BoxShadow(
                        offset: Offset(1, 5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Color.fromRGBO(0, 0, 0, 0.1)
                    )],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text("Can I delete my travels?",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("You can delete your trips by navigating to the following:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 10),
                    Text("- Navigate to the View Travel Log and locate your trip, and press the remove button on the upper right corner of the box. Click confirm and the trip has been deleted.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: whitish,
                    boxShadow: [BoxShadow(
                        offset: Offset(1, 5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        color: Color.fromRGBO(0, 0, 0, 0.1)
                    )],
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text("Can I clear my Data?",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("You can clear your data by navigating to the following:",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 10),
                    Text("- Navigate to the User Profile in the menu bar, and press the button clear all data. Once you confirm, you are requested to log back in to refresh your account.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text("PackAssist @2025",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 17,
                  color: grayblue,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Crimson",
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
