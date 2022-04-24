import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typecraft/app/app_color.dart';

import 'screens/home_screen.dart';

void main() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  AppColor.preferences = preferences;
  String? themeMode = preferences.getString('AAF_TYPECRAFT_THEME_MODE');
  if (themeMode == null) {
    await preferences.setString('AAF_TYPECRAFT_THEME_MODE', 'LIGHT');
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
