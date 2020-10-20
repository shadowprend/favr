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
  // var con = Cron();
  // con.schedule(Schedule.parse('1 * * * *	'), () async {
  //   print("cron schedule");
  //   var _firestore = FirebaseFirestore.instance;
  //   CollectionReference query = _firestore.collection('contacts');
  //   DocumentReference docref = query.doc();
  //   List<dynamic> list = [docref];
  //   list.shuffle();
  // });
  // Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  // Workmanager.registerOneOffTask("1", "firebaseTask",
  //     initialDelay: Duration(seconds: 5),
  //     constraints: Constraints(networkType: NetworkType.connected));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
      ),
      //      home: SignUpContacts(),
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

// callbackDispatcher() {
//   const firebasetask = "firebaseTask";
//   Workmanager.executeTask((task, inputData) {
//     switch (task) {
//       case firebasetask:
//         var _firestore = FirebaseFirestore.instance;
//         CollectionReference query = _firestore.collection('contacts');
// DocumentReference docref = query.doc();
//         List<dynamic> list = [docref];
//         list.shuffle();

//         break;
//     }
//     return Future.value(true);
//   });
// }
