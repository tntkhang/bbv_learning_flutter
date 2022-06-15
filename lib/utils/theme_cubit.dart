import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Cubit<ThemeData> {
  /// {@macro brightness_cubit}
  ThemeBloc() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
    primaryColor: Colors.amber,
    textTheme: const TextTheme(button: TextStyle(color: Colors.white70)),
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    primaryColor: Colors.purple,
    textTheme: const TextTheme(button: TextStyle(color: Colors.black54)),
    brightness: Brightness.dark,
  );

  /// Toggles the current brightness between light and dark.
  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
  static const PREF_KEY_CURRENT_THEME = "pref_key_current_theme";

  ThemeMode _themeMode = ThemeMode.system;

  getTheme() => _themeMode;

  setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _setThemePref(_themeMode.name);
    // notifyListeners();
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
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