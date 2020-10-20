import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'signup_name.dart';

class SignUpContacts extends StatelessWidget {
//  final userDetails = User();

  static String id = 'registration_contacts';

  final userDetails = {};
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final phoneNumber = TextEditingController();

  String verificationId;
  final _codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Detail"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'What\'s Contact Information?',
                style: formTitle,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: phoneNumber,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter mobile number";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Your Mobile Number',
                        labelText: 'Mobile Number *',
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
//                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            userDetails['phonenumber'] =
                                int.parse(phoneNumber.text);
                            phoneverification(phoneNumber.text, context);
                          } else {
                            print('valid');
                          }
                        },
                        child: Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future phoneverification(String mobile, BuildContext context) async {
    final PhoneVerificationCompleted verificationCompleted = (user) {
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      //show dialog to take input from the user
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
                title: Text("Enter SMS Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text("Done"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        var smsCode = _codeController.text.trim();
                        PhoneAuthCredential _credential;
                        _credential = PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);

                        auth
                            .signInWithCredential(_credential)
                            .then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpName(
                                      userDetails: userDetails,
                                    ),
                                  ),
                                ))
                            .catchError((onError) => print(onError));
                      }),
                  FlatButton(
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        auth.verifyPhoneNumber(
                          phoneNumber: mobile,
                          verificationCompleted: verificationCompleted,
                          verificationFailed: verificationFailed,
                          forceResendingToken: forceResendingToken,
                        );
                      },
                      child: Text("Resend"))
                ],
              ));
    };
    FirebaseAuth _auth = FirebaseAuth.instance;
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
