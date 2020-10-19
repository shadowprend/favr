import 'dart:convert';
import 'package:favr/screens/servicer_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:favr/models/user.dart';
import 'package:favr/models/userdata.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {
  static String id = 'signin';
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();

  final _password = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  final userdata = UserData();

  bool showSpinner = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Null> _logOut() async {
    await SignIn.facebookSignIn.logOut();
  }

  void loginRestriction(value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Email',
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please type an email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: 'Enter Password',
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Your password needs to be atleast 6 characters';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final newUser =
                                    _auth.signInWithEmailAndPassword(
                                        email: _email.text,
                                        password: _password.text);

                                if (newUser != null) {
                                  newUser.then((value) async {
                                    await _firestore
                                        .collection('usersrole')
                                        .where('uid', isEqualTo: value.user.uid)
                                        .get()
                                        .then(
                                      (value) {
                                        for (var val in value.docs) {
                                          final role = val.data()['role'];

                                          switch (role) {
                                            case 'servicer':
                                              Navigator.pushNamed(context,
                                                  ServicerDashboard.id);
                                              break;
                                            case 'subscriber':
                                              Navigator.pushNamed(
                                                  context, Dashboard.id);
                                              break;
                                            default:
                                              print(
                                                  'You have no permission to Login');
                                              break;
                                          }
                                        }
                                      },
                                    );
                                  });
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              print('Invalid');
                            }
                          },
                          child: Text('Sign In'),
                        ),
                      ),
//                    SizedBox(
//                      width: double.infinity,
//                      child: RaisedButton(
//                        padding: const EdgeInsets.all(8.0),
//                        textColor: Colors.white,
//                        color: Colors.blue,
//                        onPressed: () async {
//                          facebookSignIn.logIn(
//                              ['email', 'public_profile']).then((result) async {
//                            switch (result.status) {
//                              case FacebookLoginStatus.loggedIn:
//                                final token = result.accessToken.token;
//                                AuthCredential authCredential =
//                                    FacebookAuthProvider.credential(token);
//
//                                final newUser =
//                                    _auth.signInWithCredential(authCredential);
//
//                                if (newUser != null) {
//                                  final graphResponse = await http.get(
//                                      'https://graph.facebook.com/v2.12/me?fields=first_name,last_name&access_token=${token}');
//                                  final profile =
//                                      jsonDecode(graphResponse.body);
//                                  var favuser = FavrUser.fromJson(profile);
//                                  var userinfo = {
//                                    "firstname": profile['first_name'],
//                                    "location": 'none',
//                                    "lastname": profile['last_name'],
//                                    "subscriber": true
//                                  };
//                                  userdata
//                                      .isUserDataExist()
//                                      .then((value) => print(value));
//                                  userdata.updateUserData(userinfo);
////                                  Navigator.pushNamed(context, Dashboard.id);
//                                }
//                                break;
//                              case FacebookLoginStatus.cancelledByUser:
//                                print('Cancel');
//                                break;
//                              case FacebookLoginStatus.error:
//                                print(result.errorMessage);
//                                break;
//                            }
//                          }).catchError((e) {
//                            print(e);
//                          });
//                        },
//                        child: Text('SignIn with Facebook'),
//                      ),
//                    ),
//                    SizedBox(
//                      width: double.infinity,
//                      child: RaisedButton(
//                        padding: const EdgeInsets.all(8.0),
//                        textColor: Colors.white,
//                        color: Colors.blue,
//                        onPressed: () async {
//                          try {
//                            GoogleSignInAccount googleuser =
//                                await _googleSignIn.signIn();
//                            GoogleSignInAuthentication googleAuth =
//                                await googleuser.authentication;
//                            final token = googleAuth.accessToken;
//                            AuthCredential credential =
//                                GoogleAuthProvider.credential(
//                                    idToken: googleAuth.idToken,
//                                    accessToken: googleAuth.accessToken);
//
//                            final newUser =
//                                await _auth.signInWithCredential(credential);
//
//                            if (newUser != null) {
//                              print(token);
//                              final graphResponse = await http.get(
//                                  'https://www.googleapis.com/oauth2/v3/userinfo?access_token=${token}');
//                              final profile = jsonDecode(graphResponse.body);
//
//                              var favuser = FavrUser.fromJson(profile);
//                              var userinfo = {
//                                "firstname": profile['given_name'],
//                                "location": 'none',
//                                "lastname": profile['family_name'],
//                                "picture": profile['picture'],
//                                "subscriber": true
//                              };
//                              userdata.updateUserData(userinfo);
//                            }
//                          } catch (e) {
//                            print(e);
//                          }
//                        },
//                        child: Text('SignIn with Google'),
//                      ),
//                    ),
//                    SizedBox(
//                      width: double.infinity,
//                      child: RaisedButton(
//                        padding: const EdgeInsets.all(8.0),
//                        textColor: Colors.white,
//                        color: Colors.blue,
//                        onPressed: () {
//                          _logOut();
//                        },
//                        child: Text('Signout'),
//                      ),
//                    ),
                      SizedBox(height: 20.0),
                      Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Don\'t have an account?'),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Register',
                              style: TextStyle(color: Colors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        child: Text(
                          'Forgot Your Password?',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
