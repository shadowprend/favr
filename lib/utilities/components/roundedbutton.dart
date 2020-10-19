import 'package:flutter/material.dart';
import 'contants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
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
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          width: size.width * 0.8,
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
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ],
    );
  }
}
