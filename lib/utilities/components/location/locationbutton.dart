import 'package:flutter/material.dart';

import '../contants.dart';

class LocationButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const LocationButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColorButton,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: size.width,
          child: ClipRRect(
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              color: color,
              onPressed: press,
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
