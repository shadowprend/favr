import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
var user = _auth.currentUser;
var displayEmail = user.email;
var name = user.displayName;
var phone = user.phoneNumber;

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var textcontroller = TextEditingController(text: displayEmail);
    var namecontroller = TextEditingController(text: name);
    var phonecontroller = TextEditingController(text: phone);

    Widget text = Container(
      child: Text(
        "Contact info",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
    Widget button = SizedBox(
        width: double.infinity,
        child: RaisedButton(
          autofocus: true,
          textColor: Colors.white,
          padding: EdgeInsets.all(8.0),
          color: Colors.blue,
          onPressed: () async {
            _firestore
                .collection("userdata")
                .doc(user.uid)
                .update({
                  "firstname": namecontroller.text,
                  "mobilenumber": phonecontroller.text,
                })
                .then((value) => print("update success"))
                .catchError((error) => ("error update"));
          },
          child: Text("Update"),
        ));
    Widget email = Container(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Email address"),
        enabled: false,
        controller: textcontroller,
      ),
    );
    Widget mobile = Container(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "Mobile number", contentPadding: EdgeInsets.all(8.0)),
        controller: phonecontroller,
      ),
    );
    Widget firstname = Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: "First name"),
              controller: namecontroller,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: "Last name"),
            ),
          ),
        ],
      ),
    );
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: ListView(
          children: [text, firstname, email, mobile, button],
        ));
  }
}
