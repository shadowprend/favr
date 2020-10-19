import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final TextEditingController textEditingController;
  InputField({this.hintText, this.textEditingController, this.validator});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }
}
