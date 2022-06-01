import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const PREF_KEY_CURRENT_THEME = "pref_key_current_theme";

  setThemePref(String value) async {
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