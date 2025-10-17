import 'package:packassist/screens/scaffoldShow.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:packassist/screens/colors.dart';
import 'package:packassist/screens/validators.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class RegisterUser extends StatefulWidget {
  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  //initialize supabase client
  final supabase = Supabase.instance.client;

  //input for db
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();

  //visibility for password
  bool _obscurePass = true;
  bool _obscurePassConfirm = true;

  //visibility for confirm email
  bool _isVisible = false;

  //loading for db processing
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (firstnameController.text.trim().isEmpty || lastnameController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty || confirmpasswordController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {
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

    if (passwordMatch(passwordController.text.trim(),
        confirmpasswordController.text.trim()) == false) {
      showSnackBar(context, "Password does not match.");
      return;
    }

    try {

      //if all requirements are met, they proceed dito
      setState(() {
        _isLoading = true;
      });

      //check for duplicate email
      final emailExist = await supabase.from('profiles').select().eq(
          'email', emailController.text.trim()).maybeSingle();

      if (emailExist != null) {
        showSnackBar(context, "Email address already in use. Please use another email or log in.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user == null) {
        showSnackBar(context, "Registration failed. Please try again.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      //register to profiles as well
      final addProfile = await supabase.from('profiles').insert(
        {
          'user_id': response.user!.id,
          'email': emailController.text.trim(),
          'first_name': firstnameController.text.trim(),
          'last_name': lastnameController.text.trim()
        }
      );

      setState(() {
        _isLoading = false;
        _isVisible = true;
      });

    } on AuthException catch (exception) {

      if (exception.message.toLowerCase().contains("already registered")) {
        showSnackBar(context, "Auth Error: ${exception.message}.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      else {
        showSnackBar(context, "Error: ${exception.message}.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

    } on Exception catch (exception) {
      if (exception.toString().toLowerCase().contains("profiles_email_key")) {
        showSnackBar(context,
            "Email is already registered to an account. Please use another email address or log in using the email.");
        setState(() {
          _isLoading = false;
          return;
        });
      }
      else {
        showSnackBar(context, "Error: $exception.");
        setState(() {
          _isLoading = false;
        });
        return;
      }
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
                        image: AssetImage('assets/images/open-suit3.jpg'),
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
                        icon: Icon(Icons.chevron_left_rounded, size: 40, color: whitish,)
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontFamily: 'Alice',
                          fontSize: 50,
                          color: whitish,
                          fontWeight: FontWeight.bold,
                            shadows: [Shadow(
                                offset: Offset(1, 3),
                                blurRadius: 10,
                                color: Color.fromRGBO(0, 0, 0, 0.1)
                            )]
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        "Your packing\njourney starts here",
                        style: TextStyle(
                            fontFamily: 'Crimson',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: whitish,
                            shadows: [Shadow(
                                offset: Offset(1, 3),
                                blurRadius: 10,
                                color: Color.fromRGBO(0, 0, 0, 0.1)
                            )]
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Container(
                      width: 210, height: 200,
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

                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            fontFamily: "Alice",
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: black
                        ),
                      ),

                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Expanded(
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                    color: creamwhite,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),

                                child: TextField(
                                  controller: firstnameController,
                                  style: TextStyle(
                                      fontFamily: "Crimson",
                                      fontWeight: FontWeight.bold,
                                      color: black
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "First name",

                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontFamily: "Crimson",
                                          fontWeight: FontWeight.bold,
                                          color: sage
                                      )
                                  ),
                                ),
                              )
                          ),

                          SizedBox(width: 20),

                          Expanded(
                            child: Container(
                              height: 50, width: double.infinity,
                              padding: EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                  color: creamwhite,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                              ),

                              child: TextField(
                                controller: lastnameController,
                                style: TextStyle(
                                    fontFamily: "Crimson",
                                    fontWeight: FontWeight.bold,
                                    color: black
                                ),
                                decoration: InputDecoration(
                                    hintText: "Last name",

                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        fontFamily: "Crimson",
                                        fontWeight: FontWeight.bold,
                                        color: sage
                                    )
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 20),

                        Container(
                          height: 50, width: double.infinity,
                          padding: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                              color: sand,
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

                      SizedBox(height: 20),

                      Container(
                        padding: EdgeInsets.only(left: 20, top: 4),
                        height: 50, width: double.infinity,
                        decoration: BoxDecoration(
                            color: sagegreen,
                            borderRadius: BorderRadius.all(Radius.circular(5))
                        ),

                        child: TextField(
                          obscureText: _obscurePassConfirm,
                          controller: confirmpasswordController,
                          style: TextStyle(
                              fontFamily: "Crimson",
                              fontWeight: FontWeight.bold,
                              color: black
                          ),
                          decoration: InputDecoration(
                              hintText: "Confirm Password",

                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontFamily: "Crimson",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),

                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      _obscurePassConfirm = !_obscurePassConfirm;
                                    });
                                  },
                                  icon: _obscurePassConfirm ? Icon(Icons.visibility_off_rounded, color: black,) : Icon(Icons.visibility_rounded, color: black,))
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: creamwhite
                        ),
                      ),

                      SizedBox(height: 25),

                      ElevatedButton(
                          onPressed: _isLoading ? null : () {registerUser();},

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
                              "Register",
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
                                  color: whitish,
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

              Visibility(
                visible: _isVisible,
                child: Container(
                  width: double.infinity, height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg4.jpg"),
                          fit: BoxFit.cover
                      )
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: (){
                                setState(() {
                                  _isVisible = false;
                                });
                              },
                              icon: Icon(Icons.chevron_left_rounded, size: 40, color: black,)
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Container(
                        width: 200, height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/emailConfirm.png')
                          )
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Check your",
                            style: TextStyle(
                                fontFamily: "Alice",
                                fontWeight: FontWeight.bold,
                                color: black,
                                fontSize: 40
                            ),
                          ),

                          SizedBox(width: 7),

                          Text(
                            textAlign: TextAlign.center,
                            "email",
                            style: TextStyle(
                                fontFamily: "Alice",
                                fontWeight: FontWeight.bold,
                                color: sage,
                                fontSize: 40
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 40),

                      Text(
                        textAlign: TextAlign.center,
                        "We've sent a confirmation link\nto your email.",
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontWeight: FontWeight.bold,
                            color: black,
                            fontSize: 20
                        ),
                      ),

                      SizedBox(height: 40),

                      Text(
                        textAlign: TextAlign.center,
                        "Clink the link in your email\nto verify your account.",
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontWeight: FontWeight.bold,
                            color: black,
                            fontSize: 20
                        ),
                      ),

                      SizedBox(height: 60),

                      Text(
                        textAlign: TextAlign.center,
                        "Login to finalize account creation.",
                        style: TextStyle(
                            fontFamily: "Crimson",
                            fontWeight: FontWeight.bold,
                            color: grayblue,
                            fontSize: 15
                        ),
                      ),

                      SizedBox(height: 10),

                      ElevatedButton(
                          onPressed: (){
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: grayblue,
                            overlayColor: creamwhite,
                            minimumSize: Size(200, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5))
                            )
                          ),
                          child:
                          Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "Alice",
                              fontWeight: FontWeight.bold,
                              color: creamwhite,
                              fontSize: 17
                            ),
                          )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
      ),
    );
  }
}