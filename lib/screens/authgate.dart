import 'package:flutter/cupertino.dart';
import 'package:packassist/screens/preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:packassist/screens/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context){
    final session = Supabase.instance.client.auth.currentSession;

    if (session !=  null){
      return Home(); //Homepage dapat
    }
    else {
      return PreviewPage();
    }
  }
}