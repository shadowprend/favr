import 'package:favr/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/utilities/constant.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
var user = _auth.currentUser;
var name = user.displayName;
var email = user.email;
var photo = user.photoURL;
final FacebookLogin facebookSignIn = FacebookLogin();
String image(String image) {
  if (image.isEmpty) {
    getInitials(name);
  }
  return getInitials(name);
}

class MainDrawer extends StatelessWidget {
  var i = ";";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 200,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage((photo == user.photoURL.isEmpty
                  ? getInitials(name)
                  : getInitials(name))),
              child: Text(
                getInitials(''),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            accountEmail: Text(email),
            accountName: Text(name),
          ),
          ListTile(
            title: Text('My Profile'),
            leading: Icon(Icons.person_pin),
          ),
          ListTile(
            title: Text('Help Center'),
            leading: Icon(Icons.help),
          ),
          ListTile(
            title: Text('Terms & Condition / Privacy'),
            leading: Icon(Icons.find_in_page),
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              _auth.signOut();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            leading: Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }
}
