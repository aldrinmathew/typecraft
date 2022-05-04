import 'package:flutter/material.dart';

import '../model/preferences.dart';

class AppColor {
  static bool isDarkMode = false;

  static const Color light = Colors.white;

  static const Color dark = Color(0xFF222222);

  static Color get extremeLight => isDarkMode ? Colors.black : Colors.white;

  static Color get extremeDark => isDarkMode ? Colors.white : Colors.black;

  static Color get main => isDarkMode ? dark : light;

  static Color get contrast => isDarkMode ? light : dark;

  static Color style = Colors.green;

  static Color alternative = Colors.blue;

  static Color error = Colors.red;

  static T chooser<T>(T lightMode, T darkMode) {
    if (isDarkMode) {
      return darkMode;
    } else {
      return lightMode;
    }
  }

  static void switcher(ThemeSwitchMode mode) {
    if (mode == ThemeSwitchMode.dark && !isDarkMode) {
      isDarkMode = true;
      Preferences.themeMode = ThemeSwitchMode.dark;
    } else if (mode == ThemeSwitchMode.light && isDarkMode) {
      isDarkMode = false;
      Preferences.themeMode = ThemeSwitchMode.light;
    } else {
      isDarkMode = !isDarkMode;
      if (isDarkMode) {
        Preferences.themeMode = ThemeSwitchMode.dark;
      } else {
        Preferences.themeMode = ThemeSwitchMode.light;
      }
    }
  }
}

enum ThemeSwitchMode { light, dark, change }
