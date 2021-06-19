import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber_rider/AllWidget/progressDialog.dart';
import 'package:uber_rider/Allscreen/RegistrationScreen.dart';
import 'package:uber_rider/Allscreen/mainscreen.dart';
import 'package:uber_rider/main.dart';

class LoginScreen extends StatefulWidget {
  static const String idScreen = "Login";
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70.0,
            ),

            /// providing image logo
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              child: Container(
                child: Image(
                  image: AssetImage('images/logo.png'),
                  width: 350,
                  height: 200,
                  alignment: Alignment.center,
                ),
              ),
            ),

            //// simple text a simple text//////////

            Text(
              "Login as a Rider",
              style: TextStyle(fontFamily: 'Brand bold', fontSize: 20.0),
            ),

            //////////////////////////<<<<<<<<<<<<== email===================>>>>>>
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Enter your Email",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      )),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  //////////////////////////<<<<<<<<<<<<== password===================>>>>>>
                  SizedBox(
                    height: 10.0,
                  ),

                  // making text field for password
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Enter your password",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      )),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  //////////////////////////<<<<<<<<<<<<== button ===================>>>>>>
                  SizedBox(
                    height: 20.0,
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "password can not be Empty", context);
                        }
                        if (!(emailTextEditingController.text.contains("@") &&
                            emailTextEditingController.text.contains("."))) {
                          displayToastMessage("Email is not Valid ", context);
                        }
                        loginAndAuthenticateUser(context);
                      }),

                  //////////////////////make other button////////////////////
                  Divider(
                    color: Colors.grey,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            registrationScreen.idScreen, (route) => false);
                      },
                      child: Text(
                        "Don not have an account ? Register here ",
                        style:
                            TextStyle(fontFamily: "Signatra", fontSize: 20.0),
                      )),
                ],
              ),
            ),
            // making a password field
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      // ignore: non_constant_identifier_names
      builder: (BuildContext Context) {
        return ProgressDialog(
          message: "Authenticating please wait",
        );
      },
    );

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((onError) {
      Navigator.pop(context);
      displayToastMessage("Error" + onError, context);
    }))
        .user;

    if (_firebaseAuth != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are Logged-in now", context);
        } else {
          _firebaseAuth.signOut();
          displayToastMessage(
              "No record found please create new account", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Error found", context);
    }
  }
}
