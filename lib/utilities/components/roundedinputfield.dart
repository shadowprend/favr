import 'package:flutter/material.dart';
import 'text_field_container.dart';
import 'contants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController email;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Please type an email';
          }
          return null;
        },
        controller: email,
        onChanged: onChanged,
        cursorColor: kPrimaryColorButton,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
