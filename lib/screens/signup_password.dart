import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';

class SignupPassword extends StatelessWidget {
  static String id = 'registration_password';
  final userDetails;
  SignupPassword({this.userDetails});
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Name"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Password',
                style: formTitle,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Password',
                        labelText: 'Password *',
                      ),
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
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            userDetails['password'] = password.text;
                            try {
                              print(userDetails);
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: userDetails['email'],
                                      password: userDetails['password']);
                              if (newUser != null) {
                                print('Yeah');
                                Navigator.pushNamed(context, Dashboard.id);
                              }
                            } catch (e) {
                              print(e);
                            }
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
