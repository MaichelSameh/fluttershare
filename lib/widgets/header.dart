import 'package:flutter/material.dart';

AppBar header(BuildContext context, {String text = "FlutterShare"}) {
  bool isAppTitle;
  if (text == "FlutterShare") {
    isAppTitle = true;
  } else {
    isAppTitle = false;
  }

  return AppBar(
      title: Text(
        text,
        style: TextStyle(
            fontFamily: isAppTitle ? "Signatra" : "",
            fontSize: isAppTitle ? 50 : 22,
            color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).accentColor);
}
