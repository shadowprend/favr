import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'signup_email.dart';

class SignUpName extends StatelessWidget {
  static String id = 'registration_name';
  final userDetails;
  SignUpName({this.userDetails});

  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();

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
                'What\'s is your name?',
                style: formTitle,
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: firstName,
                            decoration: InputDecoration(
                              hintText: 'Enter Your First Name',
                              labelText: 'First Name *',
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Flexible(
                          child: TextFormField(
                            controller: lastName,
                            decoration: InputDecoration(
                              hintText: 'Enter Your Last Name',
                              labelText: 'Last Name *',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            userDetails['firstName'] = firstName.text;
                            userDetails['lastName'] = lastName.text;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpEmail(
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
