import 'package:favr/screens/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:favr/screens/signin.dart';
import 'package:favr/screens/signup_contacts.dart';
import 'package:favr/screens/signup_email.dart';
import 'package:favr/screens/signup_name.dart';
import 'package:favr/screens/signup_password.dart';
import 'package:favr/screens/dashboard.dart';
import 'package:favr/screens/search.dart';
import 'screens/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
      ),
      initialRoute: SignIn.id,
      routes: {
        SignUpContacts.id: (context) => SignUpContacts(),
        SignUpName.id: (context) => SignUpName(),
        SignUpEmail.id: (context) => SignUpEmail(),
        SignupPassword.id: (context) => SignupPassword(),
        LocationScreen.id: (context) => LocationScreen(),
        SignIn.id: (context) => SignIn(),
        Dashboard.id: (context) => Dashboard(),
        Search.id: (context) => Search(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
