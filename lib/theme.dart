import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: kAppBar,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      textTheme:
      TextTheme(headline6: TextStyle(fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold)),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey,
      space: 20,
    ),
  );
}

ThemeData themeDark() {
  return ThemeData(
    brightness: Brightness.dark,
    accentColor: kAccentColor,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      textTheme:
      TextTheme(headline6: TextStyle(fontSize: 22.0, color: Colors.white,fontWeight: FontWeight.bold)),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}