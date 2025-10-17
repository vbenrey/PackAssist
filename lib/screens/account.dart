import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/colors.dart';
import 'package:packassist/screens/scaffoldShow.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:packassist/screens/validators.dart';


//edit password, edit email, edit name

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {

  //container for names:
  String? firstName;
  String? lastName;
  String? email;

  //for loading and holding
  bool _isLoading = false;
  bool _isEdit = false; bool _isEdit1 = false; bool _isEdit2 = false; bool _isEdit3 = false; bool _isEdit4 = false;
  bool _obscureCurrentPass = true;
  bool _obscureNewPass = true;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    super.dispose();
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

  Future<void> saveChanges() async {
    final supabase = Supabase.instance.client;
    final userID = supabase.auth.currentUser!.id;
    final userEmail = supabase.auth.currentUser!.email;

    setState(() {
      _isLoading = true;
    });
    try {

      //all below are valid
      if (firstNameController.text.trim().isEmpty == false) {
        await supabase.from('profiles').update({
          'first_name': firstNameController.text.trim()
        }).eq('user_id', userID);
      }

      if (lastNameController.text.trim().isEmpty == false) {
        await supabase.from('profiles').update({
          'last_name': lastNameController.text.trim()
        }).eq('user_id', userID);
      }

      if (emailController.text.trim().isEmpty == false) {

        if (emailController.text.trim() == userEmail){
          showSnackBar(context, "Same email address used. Please use a different email address.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (emailChecker(emailController.text.trim()) == false){
          showSnackBar(context, "Invalid email address. Please use a valid email address.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await supabase.auth.updateUser(UserAttributes(
          email: emailController.text.trim()
        ));

        await supabase.from('profiles').update({
          'email': emailController.text.trim()
        }).eq('user_id', userID);

        setState(() {
          _isLoading = false;
        });

        showSnackBar(context, 'Login again to finalize changes.');

        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
        return;
      }

      if ((passwordController.text.trim().isEmpty == true && newPasswordController.text.trim().isEmpty == false)
      || passwordController.text.trim().isEmpty == false && newPasswordController.text.trim().isEmpty == true) {
        showSnackBar(context, "Please fill out missing password fields.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (passwordController.text.trim().isEmpty == false && newPasswordController.text.trim().isEmpty == false) {

        if (passwordController.text.trim() == newPasswordController.text.trim()) {
          showSnackBar(context, "Passwords are the same.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (passwordChecker(newPasswordController.text.trim()) == false) {
          showSnackBar(context, "Password must be at least 8 characters and must include uppercase, lowercase, and a symbol.");
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final response = await supabase.auth.signInWithPassword(
          email: userEmail,
          password: passwordController.text.trim(),
        );

        if (response.user == null) {
          showSnackBar(context, 'Incorrect password.');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        await supabase.auth.updateUser(UserAttributes(
          password: newPasswordController.text.trim()
        ));

        showSnackBar(context, 'Login again to finalize changes.');

        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });

      showSnackBar(context, 'Changes saved.');

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });

    } on AuthException catch (exception){
      showSnackBar(context, 'Auth Error: ${exception.message}.');
      setState(() {
        _isLoading = false;
      });
      return;

    } on Exception catch (exception) {
      showSnackBar(context, 'Error: $exception.');
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
              height: MediaQuery.of(context).size.height * 0.3,
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
                      "Profile\nInformation",
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
                      "Update your personal information.",
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                            child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "First name",
                                  style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: black
                                  ),
                                ),
                                TextField(
                                  controller: firstNameController,
                                  readOnly: !_isEdit,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: BorderSide.none
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                      hintText: "$firstName",
                                      hintStyle: TextStyle(
                                          fontFamily: 'Crimson',
                                          fontWeight: FontWeight.bold,
                                          color: sagegreen
                                      ),

                                      filled: true,
                                      fillColor: creamwhite,

                                      suffixIcon: IconButton(
                                          onPressed: (){
                                            setState(() {
                                              _isEdit = !_isEdit;
                                            });
                                          },
                                          icon: _isEdit ? Icon(Icons.check, color: sagegreen, fontWeight: FontWeight.bold) : Icon(Icons.edit, color: sagegreen)
                                      )
                                  ),

                                  style: TextStyle(
                                      color: black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Crimson'
                                  ),
                                ),
                              ],
                            )
                        ),

                        SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Last name",
                                style: TextStyle(
                                    fontFamily: 'Crimson',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: black
                                ),
                              ),
                              TextField(
                                controller: lastNameController,
                                readOnly: !_isEdit1,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        borderSide: BorderSide.none
                                    ),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                    hintText: "$lastName",
                                    hintStyle: TextStyle(
                                        fontFamily: 'Crimson',
                                        fontWeight: FontWeight.bold,
                                        color: sagegreen
                                    ),

                                    filled: true,
                                    fillColor: creamwhite,

                                    suffixIcon: IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _isEdit1 = !_isEdit1;
                                          });
                                        },
                                        icon: _isEdit1 ? Icon(Icons.check, color: sagegreen, fontWeight: FontWeight.bold) : Icon(Icons.edit, color: sagegreen)
                                    )
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
                        )
                      ],
                    ),

                      SizedBox(height: 20),

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
                            readOnly: !_isEdit2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: "$email",
                                hintStyle: TextStyle(
                                    fontFamily: 'Crimson',
                                    fontWeight: FontWeight.bold,
                                    color: sagegreen
                                ),

                                filled: true,
                                fillColor: creamwhite,

                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _isEdit2 = !_isEdit2;
                                      });
                                    },
                                    icon: _isEdit2 ? Icon(Icons.check, color: sagegreen, fontWeight: FontWeight.bold) : Icon(Icons.edit, color: sagegreen)
                                )
                            ),

                            style: TextStyle(
                                color: black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Crimson'
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            textAlign: TextAlign.justify,
                            "Note: Click the confirmation link sent to your current email address and new email address to change your email.",
                            style: TextStyle(
                                fontFamily: 'Crimson',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: grayblue
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),

                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                            color: creamwhite
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Change Password",
                        style: TextStyle(
                            fontFamily: 'Crimson',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black
                        ),
                      ),

                      Text(
                        textAlign: TextAlign.justify,
                        "Note: To reset password, enter your current password and new password.",
                        style: TextStyle(
                            fontFamily: 'Crimson',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: grayblue
                        ),
                      ),

                      SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Current Password",
                            style: TextStyle(
                                fontFamily: 'Crimson',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black
                            ),
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: _obscureCurrentPass,
                            readOnly: !_isEdit3,
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

                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _obscureCurrentPass = !_obscureCurrentPass;
                                          });
                                        },
                                        icon: _obscureCurrentPass ? Icon(Icons.visibility_off_rounded, color: sagegreen,) : Icon(Icons.visibility_rounded, color: sagegreen,)
                                    ),

                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _isEdit3 = !_isEdit3;
                                          });
                                        },
                                        icon: _isEdit3 ? Icon(Icons.check, color: sagegreen, fontWeight: FontWeight.bold) : Icon(Icons.edit, color: sagegreen)
                                    )
                                  ],
                                )
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

                      SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "New Password",
                            style: TextStyle(
                                fontFamily: 'Crimson',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black
                            ),
                          ),
                          TextField(
                            controller: newPasswordController,
                            obscureText: _obscureNewPass,
                            readOnly: !_isEdit4,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: BorderSide.none
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                hintText: "Enter new password",
                                hintStyle: TextStyle(
                                    fontFamily: 'Crimson',
                                    fontWeight: FontWeight.bold,
                                    color: grayblue
                                ),

                                filled: true,
                                fillColor: creamwhite,

                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _obscureNewPass = !_obscureNewPass;
                                          });
                                        },
                                        icon: _obscureNewPass ? Icon(Icons.visibility_off_rounded, color: sagegreen,) : Icon(Icons.visibility_rounded, color: sagegreen,)
                                    ),

                                    IconButton(
                                        onPressed: (){
                                          setState(() {
                                            _isEdit4 = !_isEdit4;
                                          });
                                        },
                                        icon: _isEdit4 ? Icon(Icons.check, color: sagegreen, fontWeight: FontWeight.bold) : Icon(Icons.edit, color: sagegreen)
                                    )
                                  ],
                                )
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

                      SizedBox(height: 30),

                      ElevatedButton(
                          onPressed: _isLoading ? null : () {
                            saveChanges();
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
                            "Save Changes",
                            style: TextStyle(
                                fontSize: 20,
                                color: sand,
                                fontFamily: 'Alice',
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),

                      SizedBox(height: 50),
                    ],
                  ),
                )
                ),
          ],
        ),
      ),
    );
  }
}