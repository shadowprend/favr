import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;

class Contacts extends StatefulWidget {
  Contacts({
    Key key,
  }) : super(key: key);

  @override
  _Contacts createState() => _Contacts();
}

Future<void> time() async {
  var current = DateTime.now();
  final tomorrowNoon =
      new DateTime(current.year, current.month, current.day + 0, 24);
  var query = _firestore.collection('contacts').orderBy('name');
  List<Query> list = [query];

  if (tomorrowNoon == current.isAfter(current)) {
    list.shuffle();
  }
}

class _Contacts extends State<Contacts> {
  @override
  void initState() {
    super.initState();
    time();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
