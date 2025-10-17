import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/colors.dart';
import 'package:packassist/screens/validators.dart';
import 'package:packassist/screens/scaffoldShow.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ClearUserData extends StatefulWidget {

  @override
  State<ClearUserData> createState() => _ClearUserDataState();
}

class _ClearUserDataState extends State<ClearUserData> {

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  //for visibility
  bool _obscurePass = true;
  bool _isLoading = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> clearUserData() async {

    final supabase = Supabase.instance.client;
    final userID = supabase.auth.currentUser!.id;
    final currentUserEmail = supabase.auth.currentUser?.email;

    if (passwordController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
      showSnackBar(context, "Fill out all the required fields.");
      return;
    }
    if (passwordChecker(passwordController.text.trim()) == false) {
      showSnackBar(context, "Password must be at least 8 characters and must include uppercase, lowercase, and a symbol.");
      return;
    }

    if (emailChecker(emailController.text.trim()) == false) {
      showSnackBar(context, "Invalid email address. Please use a valid email address.");
      return;
    }

    if (emailController.text.trim() != currentUserEmail) {
      showSnackBar(context, "Email does not match your account.");
      return;
    }

    try {

      setState(() {
        _isLoading = true;
      });

      //check if email exists, if it matches current user creds
      final response = await supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );

      await supabase.rpc('clear_userdata', params: {'currentuser_id': userID});
      //clears user data using current user's id from profiles, which then on cascade
      //deletes the travel logs and luggage of the user.
      //i made that func in supabase since users cant delete without authorization,
      //this allows users to be able to clear their data

      if (!mounted) {return;}

      setState(() {
        _isLoading = false;
      });

      showSnackBar(context, 'Account data cleared successfully. Log in to finalize changes.');

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
      return;

    } on AuthException catch (exception) {
      showSnackBar(context, "Auth Error: ${exception.message}.");
      setState(() {
        _isLoading = false;
      });
      return;

    } on Exception catch (exception) {
      showSnackBar(context, "Error: $exception.");
      setState(() {
        _isLoading = false;
      });
      return;

    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: whitish,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.32,
              decoration: BoxDecoration(
                  color: whitish,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(40), bottomLeft: Radius.circular(40)),
                  boxShadow: [BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 10,
                      spreadRadius: 5,
                      color: Color.fromRGBO(0, 0, 0, .05)
                  )]
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),

                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                            Icons.chevron_left_rounded, size: 40, color: black)
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 35),
                    child: Text(
                      "Clear\nYour Data",
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Crimson',
                          color: black,
                          fontWeight: FontWeight.bold,
                          height: 1

                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 35, top: 10),
                    child: Text(
                      "Want a fresh start?\nYou cannot restore user data after clearing.",
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Crimson',
                          color: grayblue,
                          fontWeight: FontWeight.bold

                      ),
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 40),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                  fontFamily: 'Crimson',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: black
                              ),
                            ),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: "Enter email address",
                                hintStyle: TextStyle(
                                    fontFamily: 'Crimson',
                                    fontWeight: FontWeight.bold,
                                    color: grayblue
                                ),

                                filled: true,
                                fillColor: creamwhite,
                              ),

                              style: TextStyle(
                                  color: black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Crimson'
                              ),
                            ),
                          ],
                        ),
                      ]
                  )
              ),
            ),

            Center(
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(
                                fontFamily: 'Crimson',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black
                            ),
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: _obscurePass,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide.none
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20),
                              hintText: "Enter current password",
                              hintStyle: TextStyle(
                                  fontFamily: 'Crimson',
                                  fontWeight: FontWeight.bold,
                                  color: grayblue
                              ),

                              filled: true,
                              fillColor: creamwhite,

                              suffixIcon:
                              IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _obscurePass = !_obscurePass;
                                    });
                                  },
                                  icon: _obscurePass ? Icon(Icons.visibility_off_rounded, color: sagegreen,) : Icon(Icons.visibility_rounded, color: sagegreen,)
                              ),
                            ),

                            style: TextStyle(
                                color: black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Crimson'
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Note: You cannot recover your data once cleared.",
                        style: TextStyle(
                            fontFamily: 'Crimson',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: grayblue
                        ),
                      ),
                    ]
                ),
              ),
            ),

            SizedBox(height: 30),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              height: 2,
              decoration: BoxDecoration(
                  color: creamwhite
              ),
            ),

            SizedBox(height: 30),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                  onPressed: _isLoading ? null : () {
                    clearUserData();
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
                  child: _isLoading ?

                  Center(
                    child: LoadingAnimationWidget.waveDots(color: sagegreen, size: 30),
                  )
                      :
                  Text(
                    "Clear Data",
                    style: TextStyle(
                        fontSize: 20,
                        color: sand,
                        fontFamily: 'Alice',
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            ),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}