
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final darkThemeData = ThemeData(
      primaryColor: Colors.purple,
      textTheme: const TextTheme(button: TextStyle(color: Colors.black54)),
      brightness: Brightness.dark,
      accentColor: Colors.purple
);

final lightThemeData = ThemeData(
      primaryColor: Colors.amber,
      textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
      brightness: Brightness.light,
      accentColor: Colors.amber
);

class ThemeNotifier with ChangeNotifier {
  static const PREF_KEY_CURRENT_THEME = "pref_key_current_theme";

  ThemeMode _themeMode = ThemeMode.system;

  ThemeNotifier() {
    getThemePref().then((value) => setTheme(value));
  }

  getTheme() => _themeMode;

  setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _setThemePref(_themeMode.name);
    notifyListeners();
  }

  _setThemePref(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PREF_KEY_CURRENT_THEME, value);
  }

  Future<ThemeMode> getThemePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var savedTheme = sharedPreferences.getString(PREF_KEY_CURRENT_THEME);
    if (savedTheme == ThemeMode.dark.name) {
      return ThemeMode.dark;
    } else if (savedTheme == ThemeMode.light.name) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }
}