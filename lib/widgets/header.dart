import 'package:flutter/material.dart';

AppBar header(
  context, {
  bool isAppTitle = false,
  required String titleText,
  removeBackButton = false,
}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "Fluttergram" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Pacifico" : "",
        fontSize: isAppTitle ? 30.0 : 22.0,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.secondary,
  );
}
