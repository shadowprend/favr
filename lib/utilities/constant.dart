import 'package:flutter/material.dart';

const formTitle = TextStyle(
  fontSize: 20.0,
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w600,
);

Color getColorFromColorCode(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

String getInitials(String name) => name.isNotEmpty
    ? name.trim().split(' ').map((l) => l[0]).take(2).join()
    : '';

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

String titleCase(String text) {
  if (text == null) throw ArgumentError("string: $text");

  if (text.isEmpty) return text;

  /// If you are careful you could use only this part of the code as shown in the second option.
  return text
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
