import 'package:algolia/algolia.dart';
import 'package:favr/screens/ProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favr/models/search.dart';
import 'package:favr/widgets/maindrawer.dart';
import 'package:favr/widgets/servicebox.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class Dashboard extends StatefulWidget {
  static String id = 'dashboard';
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;
  List<AlgoliaObjectSnapshot> _services = [];
  auth.User loggedInUser;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

//    getCurrentUser();
//    print(widget.userinfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PhoneBook',
          style: TextStyle(color: Colors.black45),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black45,
            ),
            onPressed: () async {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_pin,
              color: Colors.black45,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
        backgroundColor: Colors.white, // Don't show the leading button
      ),
      drawer: MainDrawer(),
      body: PaginateFirestore(
        padding: EdgeInsets.all(15.0),
        //item builder type is compulsory.
        itemBuilderType:
            PaginateBuilderType.listView, //Change types accordingly
        itemBuilder: (index, context, snapshot) => ServiceBox(
          name: snapshot.data()['name'],
          description: snapshot.data()['description'],
          image: snapshot.data()["thumbnail"],
          slug: snapshot.id,
        ),
        // orderBy is compulsory to enable pagination
        query: _firestore.collection('services').orderBy('name'),
      ),
    );
  }
}
