import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typecraft/app/app_color.dart';

import 'model/constants.dart';
import 'screens/home_screen.dart';

void main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  AppColor.preferences = preferences;
  String? themeMode = preferences.getString(themeModeKey);
  if (themeMode == null) {
    await preferences.setString(themeModeKey, 'LIGHT');
  } else if (themeMode == 'DARK') {
    AppColor.switcher(ThemeSwitchMode.dark);
  }
  runApp(const TypeCasterApp());
}

class TypeCasterApp extends StatelessWidget {
  const TypeCasterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
