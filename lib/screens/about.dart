import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/colors.dart';

class About extends StatelessWidget {
  About({super.key});
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
        title: Text("About Us",
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
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      offset: Offset(1, 5),
                      blurRadius: 10,
                      spreadRadius: 5,
                      color: Colors.black.withOpacity(.1)
                  )],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: AssetImage("assets/images/PackAssistLogo.png"),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("About Us",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("PackAssist aims to provide support and guidance to users when preparing for an awaited trip. This includes informing users of important details about their flight, such as the weather conditions and the recommended luggage to bring on your trip.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    SizedBox(height: 20),
                    Text("This project is developed by SOFTLENS from CS-301 with alignment to 6IMSOFTENG and ADET requirements.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 17,
                        color: sanddark,
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
                  color: sage,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                      offset: Offset(1, 5),
                      blurRadius: 10,
                      spreadRadius: 5,
                      color: Colors.black.withOpacity(.2)
                  )],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("SOFTLENS - MEMBERS",
                      style: TextStyle(
                        fontSize: 25,
                        color: black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Crimson",
                      ),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Lenon, Danielle Laurence B:",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                            SizedBox(width: 10),
                            Text("UI/UX\nand Tester",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Liwag, Seiji Luis S:",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                            SizedBox(width: 10),
                            Text("UI/UX\nand Tester",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Ochoa, Bianca Claire L:",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                            SizedBox(width: 10),
                            Text("Full-Stack\nDeveloper",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Ochoa, Bianca Venice L",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                            SizedBox(width: 10),
                            Text("Full-Stack\nDeveloper",style: TextStyle(
                              fontSize: 15,
                              color: black,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Crimson",
                            )),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
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
