import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/screens/location.dart';
import 'package:favr/screens/signup_contacts.dart';
import 'package:favr/utilities/components/roundedpassword.dart';
import 'package:favr/utilities/components/roundedbutton.dart';
import 'package:favr/utilities/components/roundedinputfield.dart';
import 'package:favr/utilities/components/socialicon.dart';

import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:favr/models/user.dart';
import 'package:favr/models/userdata.dart';

class SignIn extends StatelessWidget {
  static String id = 'signin';
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final userdata = UserData();
  final _firestore = FirebaseFirestore.instance;
  var phonecontroller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final FacebookLogin facebookSignIn = FacebookLogin();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<Null> _logOut() async {
    await facebookSignIn.logOut();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
      value,
      style: TextStyle(fontSize: 21),
    )));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome, Logged In',
                style: formTitle,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RoundedInputField(
                        hintText: "Enter Your Email",
                        email: _email,
                        onChanged: (value) {},
                      ),
                      RoundedPasswordField(
                        hintText: "Password",
                        email: _password,
                        onChanged: (value) {},
                      ),
                      SizedBox(
                        height: 15.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                'Forgot  Password?',
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      RoundedButton(
                        text: "Sign In",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              final newUser =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email.text,
                                      password: _password.text);

                              if (newUser != null) {
                                CircularProgressIndicator();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard()));
                              }
                            } catch (e) {
                              showInSnackBar("invalid");
                            }
                          } else {
                            showInSnackBar("invalid username/password");
                          }
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Don\'t have an account?'),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpContacts())))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocalIcon(
                        iconSrc: "assets/icons/icons-facebook.svg",
                        press: () async {
                          facebookSignIn.logIn(
                              ['email', 'public_profile']).then((result) async {
                            switch (result.status) {
                              case FacebookLoginStatus.loggedIn:
                                final token = result.accessToken.token;
                                AuthCredential authCredential =
                                    FacebookAuthProvider.credential(token);

                                final newUser =
                                    _auth.signInWithCredential(authCredential);
                                if (newUser != null) {
                                  final graphResponse = await http.get(
                                      'https://graph.facebook.com/me?fields=picture?redirect=0&height=200&type=normal&width=200,name,first_name,last_name,email&access_token=${token}');
                                  final profile =
                                      jsonDecode(graphResponse.body);
                                  var userinfo = {
                                    "firstname": _auth.currentUser.displayName,
                                    "location": 'none',
                                    "picture": _auth.currentUser.photoURL,
                                    "subscriber": true,
                                    "full address": 'none',
                                    "longlat": 'none',
                                    'cityslug': 'none'
                                  };

                                  CircularProgressIndicator();

                                  userdata.updateUserData(userinfo);

                                  // bool _isLocationServiceEnabled =
                                  //     await isLocationServiceEnabled();
                                  Navigator.pushNamed(
                                      context, LocationScreen.id);

                                  // LocationPermission permission =
                                  //     await checkPermission();
                                  // if (permission == true) {
                                  //   Navigator.pushNamed(context, Dashboard.id);
                                  // }

                                  _firestore
                                      .collection("userdata")
                                      .doc(_auth.currentUser.uid)
                                      .get()
                                      .then((value) => {
                                            if (value.get("longlat") == 'none')
                                              {
                                                Navigator.pushNamed(
                                                    context, LocationScreen.id)
                                              }
                                            else
                                              {
                                                Navigator.pushNamed(
                                                    context, Dashboard.id)
                                              }
                                          });

                                  var favuser = FavrUser.fromJson(profile);
                                }
                                break;
                              case FacebookLoginStatus.cancelledByUser:
                                showInSnackBar("cancel");
                                break;
                              case FacebookLoginStatus.error:
                                showInSnackBar(result.errorMessage);
                                break;
                            }
                          }).catchError((e) {
                            showInSnackBar("can't login");
                          });
                        },
                      ),
                      SocalIcon(
                        iconSrc: "assets/icons/icons-google.svg",
                        press: () async {
                          signInWithGoogle();
                          var userinfo = {
                            "firstname": _auth.currentUser.displayName,
                            "location": 'none',
                            "picture": _auth.currentUser.photoURL,
                            "subscriber": true,
                            "full address": 'none',
                            "longlat": 'none',
                            'cityslug': 'none'
                          };

                          CircularProgressIndicator();
                          userdata.updateUserData(userinfo);
                          Navigator.pushNamed(context, LocationScreen.id);
                          _firestore
                              .collection("userdata")
                              .doc(_auth.currentUser.uid)
                              .get()
                              .then((value) => {
                                    if (value.get("longlat") == 'none')
                                      {
                                        Navigator.pushNamed(
                                            context, LocationScreen.id)
                                      }
                                    else
                                      {
                                        Navigator.pushNamed(
                                            context, Dashboard.id)
                                      }
                                  });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Future<Address> convertCoordinatestoAddress(Coordinates coordinates) async {
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
