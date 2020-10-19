import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final SnackBar snackbar;
  Background({Key key, @required this.child, this.snackbar}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        padding: EdgeInsets.all(24),
        width: size.width,
        height: size.height,
        child: child,
      ),
    );
  }
}
