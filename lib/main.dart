import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/screens/authenticate/authenticate.dart';
import 'package:first/screens/authenticate/sign_in.dart';
import 'package:first/screens/profile/edit_profile.dart';
import 'package:first/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:first/screens/home/demo_page.dart';
import 'package:first/screens/authenticate/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first/screens/sos/sos.dart';
import 'package:first/screens/profile/view_profile.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therefor(e)You',  
      home: Wrapper(),
      initialRoute: '/',
      routes: {
        './home': (context) => DemoPage(),
        './sos' : (context) => HyperTrackQuickStart(),
        './viewProfile': (context) => ViewProfilePage(),
        './editProfile':(context) => SettingsForm(),
        './signIn':(context) => Wrapper(),
      
      }
    );
  }
}
