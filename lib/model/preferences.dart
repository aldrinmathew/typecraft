import 'package:shared_preferences/shared_preferences.dart';

import '../app/app_color.dart';
import '../model/constants.dart';

/// Class that handles all preferences/data used by the app
class Preferences {
  static SharedPreferences? _preferences;

  /// Gets values from local storage and assigns those to the relevant fields
  static init() async {
    _preferences = await SharedPreferences.getInstance();

    // Theme Mode

    var themeValue = _preferences?.getString(Constants.themeModeKey);
    switch (themeValue) {
      case null:
        {
          _preferences?.setString(Constants.themeModeKey, 'LIGHT');
          break;
        }
      case 'LIGHT':
        {
          _themeMode = ThemeSwitchMode.light;
          break;
        }
      case 'DARK':
        {
          _themeMode = ThemeSwitchMode.dark;
          AppColor.switcher(_themeMode);
          break;
        }
    }

    // Character Count
    var charValue = _preferences?.getInt(Constants.characterCountKey);
    switch (charValue) {
      case null:
        {
          _preferences?.setInt(Constants.characterCountKey, 0);
          break;
        }
      default:
        {
          _charCount = charValue!;
        }
    }

    // Word Count
    var wordValue = _preferences?.getInt(Constants.wordLimitKey);
    switch (wordValue) {
      case null:
        {
          _preferences?.setInt(Constants.wordLimitKey, 8);
          break;
        }
      default:
        {
          _wordCount = wordValue!;
        }
    }

    // Time Taken
    var timeValue = _preferences?.getDouble(Constants.timeTakenKey);
    switch (timeValue) {
      case null:
        {
          _preferences?.setDouble(Constants.timeTakenKey, 0.1);
          break;
        }
      default:
        {
          _timeTaken = timeValue!;
        }
    }
  }

  static ThemeSwitchMode _themeMode = ThemeSwitchMode.light;

  /// This setter is expected to be invocated after the state of the theme mode
  /// is changed in the AppColor instance
  static set themeMode(ThemeSwitchMode value) {
    _preferences?.setString(
        Constants.themeModeKey,
        (value == ThemeSwitchMode.light)
            ? 'LIGHT'
            : (value == ThemeSwitchMode.dark ? 'DARK' : (AppColor.isDarkMode ? 'DARK' : 'LIGHT')));
    _themeMode =
        value != ThemeSwitchMode.change ? value : (AppColor.isDarkMode ? ThemeSwitchMode.dark : ThemeSwitchMode.light);
  }

  static int _charCount = 0;
  static int get charCount => _charCount;
  static set charCount(int value) {
    _preferences?.setInt(Constants.characterCountKey, value);
    _charCount = value;
  }

  static int _wordCount = 0;
  static int get wordCount => _wordCount;
  static set wordCount(int value) {
    _preferences?.setInt(Constants.wordCountKey, value);
    _wordCount = value;
  }

  static int _wordLimit = 8;
  static int get wordLimit => _wordLimit;
  static set wordLimit(int value) {
    _preferences?.setInt(Constants.wordLimitKey, value);
    _wordLimit = value;
  }

  static double _timeTaken = 0.1;

  static double get timeTaken => _timeTaken;

  static set timeTaken(double value) {
    _preferences?.setDouble(Constants.timeTakenKey, value);
    _timeTaken = value;
  }
}
