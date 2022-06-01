
import 'package:flutter/material.dart';
import 'package:bbv_learning_flutter/utils/preferences.dart';

final darkThemeData = ThemeData(
      primaryColor: Colors.purple,
      textTheme: const TextTheme(button: TextStyle(color: Colors.black54)),
      brightness: Brightness.dark,
      accentColor: Colors.purple
);

final lightThemeData = ThemeData(
      primaryColor: Colors.blue,
      textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
      brightness: Brightness.light,
      accentColor: Colors.blue
);

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeNotifier() {
    // ThemePreferences().getThemePref().then((value) => setTheme(value));
  }

  getTheme() => _themeMode;

  setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    // await ThemePreferences().setThemePref(_themeMode.name);
    notifyListeners();
  }
}