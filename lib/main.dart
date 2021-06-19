import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_rider/Allscreen/RegistrationScreen.dart';
import 'package:uber_rider/Allscreen/loginScreen.dart';

import 'Allscreen/mainscreen.dart';

////////// create a refrence of database \\\\\\\\\\\\\\\\\\\\\\
DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: registrationScreen(),
      debugShowCheckedModeBanner: false,
      initialRoute: MainScreen.idScreen,
      routes: {
        registrationScreen.idScreen: (context) => registrationScreen(),
        LoginScreen.idScreen: (context) => LoginScreen(),
        MainScreen.idScreen: (context) => MainScreen()
      },
    );
  }
}
