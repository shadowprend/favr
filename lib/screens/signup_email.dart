import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favr/models/userdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'signup_password.dart';

class SignUpEmail extends StatelessWidget {
  static String id = 'registration_email';
  final userDetails;
  SignUpEmail({this.userDetails});

  final _formKey = GlobalKey<FormState>();
  final emailAddress = TextEditingController();
  UserData userdata;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Address"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'What\'s your email address?',
                style: formTitle,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailAddress,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please Enter your Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email Address',
                        labelText: 'Email Address *',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            userDetails['email'] = emailAddress.text;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPassword(
                                  userDetails: userDetails,
                                ),
                              ),
                            );
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
}
