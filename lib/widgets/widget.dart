import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text(
      'CONNECTS',
      style: TextStyle(
        letterSpacing: 2.0,

        fontSize: 30.0,
        fontFamily: 'QuiteMagical',

      ),
    ),
  );
}
InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white38,
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      )

  );
}

TextStyle simpleTextStyle()
{
  return TextStyle(
    color: Colors.white,
    fontSize: 14.0,
  );
}

TextStyle mediumTextStyle()
{
  return TextStyle(
    fontSize: 16.0,
    color: Colors.white,
  );
}
