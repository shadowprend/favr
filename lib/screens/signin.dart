import 'dart:convert';
import 'package:favr/screens/location.dart';
import 'package:favr/screens/servicer_dashboard.dart';
import 'package:favr/screens/signup_contacts.dart';
import 'package:favr/utilities/components/roundedbutton.dart';
import 'package:favr/utilities/components/roundedinputfield.dart';
import 'package:favr/utilities/components/roundedpassword.dart';
import 'package:favr/utilities/components/socialicon.dart';
import 'package:favr/widgets/maindrawer.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
      value,
      style: TextStyle(fontSize: 21),
    )));
  }

  void loginRestriction(value) {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
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
                      RoundedInputField(
                        hintText: "Email",
                      ),
                      RoundedPasswordField(
                        hintText: "Password",
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Your Password?',
                          style: TextStyle(color: Colors.lightBlue),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        child: RoundedButton(
                          text: "Sign in",
                          press: () async {
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
                              showInSnackBar('Isnvalid');
                            }
                          },
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
                                            builder: (context) =>
                                                SignUpContacts())))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SocalIcon(
                            iconSrc: "assets/icons/icons-facebook.svg",
                            press: () async {
                              facebookSignIn
                                  .logIn(['email', 'public_profile']).then(
                                      (result) async {
                                switch (result.status) {
                                  case FacebookLoginStatus.loggedIn:
                                    final token = result.accessToken.token;
                                    AuthCredential authCredential =
                                        FacebookAuthProvider.credential(token);

                                    final newUser = _auth
                                        .signInWithCredential(authCredential);
                                    if (newUser != null) {
                                      final graphResponse = await http.get(
                                          'https://graph.facebook.com/me?fields=picture?redirect=0&height=200&type=normal&width=200,name,first_name,last_name,email&access_token=${token}');
                                      final profile =
                                          jsonDecode(graphResponse.body);
                                      var userinfo = {
                                        "firstname":
                                            _auth.currentUser.displayName,
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
                                                if (value.get("longlat") ==
                                                    'none')
                                                  {
                                                    Navigator.pushNamed(context,
                                                        LocationScreen.id)
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
    );
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
