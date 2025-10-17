import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/colors.dart';
import 'package:packassist/screens/scaffoldShow.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  //initialize names and email
  String? firstName;
  String? lastName;
  String? email;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    //connect to supabase and retrieve current user id
    final supabase = Supabase.instance.client;
    final userID = supabase.auth.currentUser!.id;

    try {
      final response = await supabase.from('profiles').select(
          'first_name, last_name, email').eq('user_id', userID).single();

      setState(() {
        firstName = response['first_name'];
        lastName = response['last_name'];
        email = response['email'];
      });
    } on AuthException catch (exception) {
      showSnackBar(context, "Auth Error: ${exception.message}.");
      return;

    } on Exception catch (exception) {
      showSnackBar(context, "Error: $exception.");
      return;
    }
  }

  Future<void> signOut() async {

    try {
      await Supabase.instance.client.auth.signOut();

      showSnackBar(context, "Successfully signed out.");

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/preview');
        }
      });


    } on AuthException catch (exception) {
      showSnackBar(context, "Auth Error: ${exception.message}.");
      return;

    } on Exception catch (exception) {
      showSnackBar(context, "Error: $exception.");
      return;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitish,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/compass1.jpg"),
                    fit: BoxFit.cover
                ),
              ),
            ),

            Positioned(
              left: 20, top: 52,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded, size: 40, color: whitish,)
              ),
            ),

            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    margin: EdgeInsets.only(top: 100),
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whitish
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "${firstName ?? ''} ${lastName ?? ''}",
                        style: TextStyle(
                            fontSize: 45,
                            color: whitish,
                            fontFamily: 'Crimson',
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(
                                offset: Offset(0, 2),
                                color: grayblue,
                                blurRadius: 15
                            )
                            ]
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "${email ?? ''}",
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Crimson',
                      color: sagegreen,
                      fontWeight: FontWeight.bold,
                        shadows: [Shadow(
                          offset: Offset(0, 2),
                          color: grayblue,
                          blurRadius: 15,
                        )
                        ]
                    ),
                  ),

                  SizedBox(height: 15),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 65,
                          decoration: BoxDecoration(
                              color: whitish,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .05),
                                  blurRadius: 10,
                                  spreadRadius: 5
                              )
                              ]
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/travel');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    overlayColor: Colors.transparent,
                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Transform.rotate(
                                            angle: 0.5,
                                            child: Icon(
                                              Icons.flight_rounded,
                                              size: 25,
                                              fontWeight: FontWeight.bold,
                                              color: sand,
                                            ),
                                          ),

                                          SizedBox(width: 15),

                                          Text(
                                            "My Trips",
                                            style: TextStyle(
                                                fontSize: 19,
                                                color: black,
                                                fontFamily: 'Crimson',
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),

                                      Icon(
                                        Icons.chevron_right_rounded,
                                        size: 25,
                                        fontWeight: FontWeight.bold,
                                        color: sand,
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 30),
                        child: Text(
                          textAlign: TextAlign.start,
                          "Account Settings",
                          style: TextStyle(
                              fontFamily: 'Alice',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: sage
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(top:8),
                          width: MediaQuery.of(context).size.width * 0.8,
                            height: 65,
                          decoration: BoxDecoration(
                              color: whitish,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .05),
                                  blurRadius: 10,
                                  spreadRadius: 5
                              )
                            ]
                          ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/account').then((_) {
                                        fetchUserDetails();
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      overlayColor: Colors.transparent,
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                                Icons.people_rounded,
                                                size: 25,
                                                fontWeight: FontWeight.bold,
                                                color: sand,
                                              ),

                                            SizedBox(width: 15),

                                            Text(
                                              "Account",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  color: black,
                                                  fontFamily: 'Crimson',
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),

                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 25,
                                          fontWeight: FontWeight.bold,
                                          color: sand,
                                        ),
                                      ],
                                    )
                                ),
                              ],
                          )
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 30),
                        child: Text(
                          textAlign: TextAlign.start,
                          "Privacy & Data",
                          style: TextStyle(
                            fontFamily: 'Alice',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: sage
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.only(top:8),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 125,
                            decoration: BoxDecoration(
                              color: whitish,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, .05),
                                  blurRadius: 10,
                                  spreadRadius: 5
                              )
                              ]
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/deleteAccount');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      overlayColor: Colors.transparent,
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_remove_alt_1_rounded,
                                              size: 25,
                                              fontWeight: FontWeight.bold,
                                              color: sand,
                                            ),
                                            SizedBox(width: 15),

                                            Text(
                                              "Delete Account",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  color: black,
                                                  fontFamily: 'Crimson',
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),

                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 25,
                                          fontWeight: FontWeight.bold,
                                          color: sand,
                                        ),
                                      ],
                                    )
                                ),

                                SizedBox(height: 5),

                                Center(
                                  child: Container(
                                    height: 2,
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.04)
                                    ),
                                  ),
                                ),

                                SizedBox(height: 5),

                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/clearUserData');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      overlayColor: Colors.transparent,
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                              Icon(
                                                Icons.delete_outline_rounded,
                                                size: 25,
                                                fontWeight: FontWeight.bold,
                                                color: sand,
                                              ),

                                            SizedBox(width: 15),

                                            Text(
                                              "Clear All Data",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  color: black,
                                                  fontFamily: 'Crimson',
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),

                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 25,
                                          fontWeight: FontWeight.bold,
                                          color: sand,
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 30),
                        child: Text(
                          textAlign: TextAlign.start,
                          "More",
                          style: TextStyle(
                              fontFamily: 'Alice',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: sage
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.only(top:8),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 65,
                            decoration: BoxDecoration(
                                color: whitish,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)),
                                boxShadow: [BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, .05),
                                    blurRadius: 10,
                                    spreadRadius: 5
                                )
                                ]
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/about');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      overlayColor: Colors.transparent,
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                                Icons.info_outline_rounded,
                                                size: 25,
                                                fontWeight: FontWeight.bold,
                                                color: sand,
                                              ),

                                            SizedBox(width: 15),

                                            Text(
                                                "About",
                                              style: TextStyle(
                                                  fontSize: 19,
                                                  color: black,
                                                  fontFamily: 'Crimson',
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),

                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 25,
                                          fontWeight: FontWeight.bold,
                                          color: sand,
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )
                        ),
                      ),

                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 50),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                              onPressed: () {
                                signOut();
                              },

                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  minimumSize: Size(double.infinity, 50),
                                  backgroundColor: black,
                                  overlayColor: sagegreen,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  )
                              ),

                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: sand,
                                    fontFamily: 'Alice',
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                          ),
                        ),
                      ),
                    ],
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