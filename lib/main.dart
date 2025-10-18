import 'package:flutter/material.dart';
import 'package:packassist/screens/about.dart';
import 'package:packassist/screens/account.dart';
import 'package:packassist/screens/addluggage.dart';
import 'package:packassist/screens/authgate.dart';
import 'package:packassist/screens/clearuserdata.dart';
import 'package:packassist/screens/deleteaccount.dart';
import 'package:packassist/screens/editluggage.dart';
import 'package:packassist/screens/home.dart';
import 'package:packassist/screens/login.dart';
import 'package:packassist/screens/previewtripadd.dart';
import 'package:packassist/screens/register.dart';
import 'package:packassist/screens/trip.dart';
import 'package:packassist/screens/tutorial.dart';
import 'package:packassist/screens/userprofile.dart';
import 'package:packassist/screens/viewluggage.dart';
import 'package:packassist/screens/weather.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/preview.dart';
import 'package:packassist/screens/viewTravel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tzyniiznwltlqcxstafl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6eW5paXpud2x0bHFjeHN0YWZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwNzY1MDYsImV4cCI6MjA3MzY1MjUwNn0.8grpdT7DUfBMhrh21jkfV9ne_RdSdlXoDfaUxOhQU10',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreviewPage(),
      routes: {
        '/home':(context) => Home(),
        '/weather': (context) => Weather(),
        '/preview':(context) => PreviewPage(),
        '/authUser':(context) => AuthGate(),
        '/login':(context) => LoginUser(),
        '/register':(context) => RegisterUser(),
        '/about':(context) => About(),
        '/trip': (context) => Trip(),
        '/profile': (context) => UserProfile(),
        '/travel': (context) => Viewtravel(),
        '/previewTrip': (context) => AddTripPreview(),
        '/addLuggage': (context) => AddLuggageAndItemsPage(),
        '/viewLuggage': (context) => ViewLuggage(),
        '/editLuggage': (context) => UpdateLuggageAndItemsPage(),
        '/deleteAccount': (context) => DeleteAccount(),
        '/account': (context) => Account(),
        '/deleteAccount': (context) => DeleteAccount(),
        '/clearUserData': (context) => ClearUserData(),
        '/tutorial': (context) => Tutorial()
      },
    );
  }
}
