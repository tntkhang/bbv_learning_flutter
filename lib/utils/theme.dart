
import 'package:flutter/material.dart';

var lightThemeData = ThemeData(
    primaryColor: Colors.blue,
    textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
    brightness: Brightness.light,
    accentColor: Colors.blue);

var darkThemeData = ThemeData(
    primaryColor: Colors.purple,
    textTheme: const TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
    accentColor: Colors.purple);