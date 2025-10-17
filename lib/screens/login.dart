import 'package:packassist/screens/scaffoldShow.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:packassist/screens/colors.dart';
import 'package:packassist/screens/validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoginUser extends StatefulWidget {
  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {

  //initialize supabase client
  final supabase = Supabase.instance.client;

  //input for db
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //visibility for password
  bool _obscurePass = true;

  //loading for db processing
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (passwordController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
      showSnackBar(context, "Fill out all the required fields.");
      return;
    }

    if (emailChecker(emailController.text.trim()) == false) {
      showSnackBar(context, "Invalid email. Please use a valid email address.");
      return;
    }

    if (passwordChecker(passwordController.text.trim()) == false) {
      showSnackBar(context, "Password must be at least 8 characters and must include uppercase, lowercase, and a symbol.");
      return;
    }

    //if all requirements are met, they proceed dito
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user == null) {
        showSnackBar(context, "Login failed. Please try again.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(context, '/home');

    } on AuthException catch (exception) {
      if (exception.message.toLowerCase().contains("invalid login credentials")) {
        showSnackBar(context, "Invalid email address or password.");
        setState(() {
          _isLoading = false;
        });
        return;
      }
      else {
        showSnackBar(context, "Auth Error: ${exception.message}.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

    } on Exception catch (exception) {
      showSnackBar(context,  "Error: $exception.");
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
        child: Stack(
          children: [
            Container(
              width: double.infinity, height: MediaQuery.of(context).size.height * 0.305,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/items1.jpg'),
                      fit: BoxFit.cover
                  )
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pushReplacementNamed(context, '/preview');
                      },
                      icon: Icon(Icons.chevron_left_rounded, size: 40, color: creamwhite,)
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontFamily: 'Alice',
                          fontSize: 50,
                          color: whitish,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(
                              offset: Offset(1, 3),
                              blurRadius: 10,
                              color: Color.fromRGBO(0, 0, 0, 0.3)
                          )]
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 20, bottom: 20),
                    child: Text(
                      "Ready to pack smarter?",
                      style: TextStyle(
                        fontFamily: 'Crimson',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: whitish,
                          shadows: [Shadow(
                              offset: Offset(1, 3),
                              blurRadius: 10,
                              color: Color.fromRGBO(0, 0, 0, 0.3)
                          )]
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    width: 190, height: 200,
                    decoration: BoxDecoration(
                        color: whitish,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(40))
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
              width: double.infinity, height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg3.jpg'),
                      fit: BoxFit.cover
                  )
              ),

              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Log In",
                      style: TextStyle(
                          fontFamily: "Alice",
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: black
                      ),
                    ),

                    SizedBox(height: 30),

                    Container(
                      padding: EdgeInsets.only(left: 20),
                      height: 50, width: double.infinity,
                      decoration: BoxDecoration(
                          color: creamwhite,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),

                      child: TextField(
                        controller: emailController,
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontWeight: FontWeight.bold,
                            color: black
                        ),
                        decoration: InputDecoration(
                            hintText: "Email",

                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontFamily: "Crimson",
                                fontWeight: FontWeight.bold,
                                color: sage
                            )
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      padding: EdgeInsets.only(left: 20, top: 4),
                      height: 50, width: double.infinity,
                      decoration: BoxDecoration(
                          color: sage,
                          borderRadius: BorderRadius.all(Radius.circular(5))
                      ),

                      child: TextField(
                        obscureText: _obscurePass,
                        controller: passwordController,
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontWeight: FontWeight.bold,
                            color: black
                        ),
                        decoration: InputDecoration(
                            hintText: "Password",

                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontFamily: "Crimson",
                                fontWeight: FontWeight.bold,
                                color: Colors.black38
                            ),

                            suffixIcon: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _obscurePass = !_obscurePass;
                                  });
                                },
                                icon: _obscurePass ? Icon(Icons.visibility_off_rounded,) : Icon(Icons.visibility_rounded))
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    Container(
                      height: 2, width: double.infinity,
                      decoration: BoxDecoration(
                          color: creamwhite
                      ),
                    ),

                    SizedBox(height: 25),

                    ElevatedButton(
                        onPressed: _isLoading ? null : () {loginUser();},
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
                          "Login",
                          style: TextStyle(
                              fontSize: 20,
                              color: sand,
                              fontFamily: 'Alice',
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),

                    TextButton(
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        style: ElevatedButton.styleFrom(
                          overlayColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not yet a member?",
                              style: TextStyle(
                                fontSize: 17,
                                color: black,
                                fontFamily: 'Crimson',
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 5),

                            Text(
                              "Register Now",
                              style: TextStyle(
                                fontSize: 17,
                                color: sagegreen,
                                fontFamily: 'Crimson',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}