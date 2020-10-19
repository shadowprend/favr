import 'dart:async';

import 'package:cron/cron.dart';
import 'package:favr/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:favr/utilities/constant.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

final _firestore = FirebaseFirestore.instance;
CollectionReference query1 = _firestore.collection('contacts');
DocumentReference docref = query1.doc();

class ServiceContacts extends StatefulWidget {
  static String id = 'dashboard';
  final String serviceName;
  final String title;

  ServiceContacts({this.title, this.serviceName});

  @override
  _ServiceContacts createState() => _ServiceContacts();
}

class _ServiceContacts extends State<ServiceContacts> {
  final _auth = auth.FirebaseAuth.instance;
  String countryCode = '+63';

  List<dynamic> list = [docref];
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
          itemBuilder: (index, context, snapshot) => PopupMenuButton<String>(
                onSelected: (String value) {
                  String _phoneNumber =
                      snapshot.data()['phonenumber'].toString();

                  switch (value) {
                    case 'call':
                      {
                        _customLaunch('tel:' + countryCode + _phoneNumber);
                      }
                      break;

                    case 'message':
                      {
                        _customLaunch('sms:' + countryCode + _phoneNumber);
                      }
                      break;

                    case 'copy':
                      {
                        Clipboard.setData(
                            ClipboardData(text: '0' + _phoneNumber));
                      }
                      break;

                    default:
                      {
                        print('Error');
                      }
                      break;
                  }
                },
                offset: Offset(1, 1),
                child: ListTile(
                  title: Text(snapshot.data()['name']),
                  subtitle: Text(
                      countryCode + snapshot.data()['phonenumber'].toString()),
                  leading: CircleAvatar(
                    child: Text(
                      getInitials(snapshot.data()['name']),
                    ),
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'call',
                    child: Text('Call'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'message',
                    child: Text('Send Message'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'copy',
                    child: Text('Copy number'),
                  ),
                ],
              ),
          // orderBy is compulsory to enable pagination
          query: _firestore.collection("contacts")),
    );
  }
}
