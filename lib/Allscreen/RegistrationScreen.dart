import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_rider/AllWidget/progressDialog.dart';
import 'package:uber_rider/Allscreen/loginScreen.dart';
import 'package:uber_rider/main.dart';

// ignore: camel_case_types
class registrationScreen extends StatefulWidget {
  static const String idScreen = "Register";
  const registrationScreen({Key key}) : super(key: key);

  @override
  _registrationScreenState createState() => _registrationScreenState();
}

// ignore: camel_case_types
class _registrationScreenState extends State<registrationScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              "SignUp as a Rider",
              style: TextStyle(fontFamily: 'Brand bold', fontSize: 20.0),
            ),

            //////////////////////////<<<<<<<<<<<<== email===================>>>>>>
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //////// name ====////////////////////////////////////////////
                  TextField(
                    controller: nameTextEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      )),
                    ),
                    style: TextStyle(fontSize: 14.0),
                  ),
                  ////////////////////////////////email////////////////////
                  SizedBox(
                    height: 10.0,
                  ),
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
                  SizedBox(
                    height: 10.0,
                  ),
                  /////////////////// phone /////////////////////////
                  TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone",
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
                            "Create account",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: () {
                        if (nameTextEditingController.text.isEmpty) {
                          displayToastMessage("Name can not be Empty", context);
                        } else if (!(emailTextEditingController.text
                                .contains("@") &&
                            emailTextEditingController.text.contains("."))) {
                          displayToastMessage("Email is not Valid ", context);
                        } else if (passwordTextEditingController.text.length <
                            4) {
                          displayToastMessage(
                              "Password  must 4 characters", context);
                        } else if (phoneTextEditingController.text.isEmpty) {
                          displayToastMessage(
                              "Phone is can not be empty ", context);
                        } else {
                          registerNewUser(context);
                        }
                      }),

                  //////////////////////make other button////////////////////
                  Divider(
                    color: Colors.grey,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LoginScreen.idScreen, (route) => false);
                      },
                      child: Text(
                        "if you have an account ? click here ",
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

  // +++++++++++>>>>>>>>>>>>>>> Create New User ==================>
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
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
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((onError) {
      Navigator.pop(context);
      displayToastMessage("Error" + onError, context);
    }))
        .user;

    if (firebaseUser != null) {
      // save user to database
      // ignore: non_constant_identifier_names
      Map UserDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "password": passwordTextEditingController.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(UserDataMap);
      displayToastMessage("congrats your accounts has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      //display error
      displayToastMessage("User are not created", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
