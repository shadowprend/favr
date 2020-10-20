import 'package:favr/screens/singleprofile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:favr/utilities/constant.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chatdetailpage.dart';

class ServiceContacts extends StatefulWidget {
  static String id = 'dashboard';
  final String serviceName;
  final String title;

  ServiceContacts({this.title, this.serviceName});

  @override
  _ServiceContacts createState() => _ServiceContacts();
}

class _ServiceContacts extends State<ServiceContacts> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;
  String countryCode = '+63';

  auth.User loggedInUser;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _customLaunch(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('could not lunch $url');
    }
  }

  Future<void> readLoacationData() async {
    var query = await FirebaseFirestore.instance
        .collection("contacts")
        .doc()
        .snapshots();
    query.forEach((doc) {
      List<Map<dynamic, dynamic>> values = List.from(doc.data()['services']);
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(widget.title),
      ),
      body: PaginateFirestore(
          padding: EdgeInsets.all(15.0),
          //item builder type is compulsory.
          itemBuilderType:
              PaginateBuilderType.listView, //Change types accordingly
          itemBuilder: (index, context, snapshot) => ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleProfile(snapshot.data()),
                    ),
                  );
                },
                title: Text(snapshot.data()['name']),
                subtitle: Text(
                    countryCode + snapshot.data()['phonenumber'].toString()),
                leading: CircleAvatar(
                  child: Text(
                    getInitials(snapshot.data()['name']),
                  ),
                ),
              ),
          // orderBy is compulsory to enable pagination
          query: _firestore.collection("contacts")),
    );
  }
}
