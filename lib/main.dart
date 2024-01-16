import 'package:flutter/material.dart';

import 'model/preferences.dart';
import 'screens/home_screen.dart';

void main() async {
  await Preferences.init();
  runApp(const TypeCraftApp());
}

class TypeCraftApp extends StatelessWidget {
  const TypeCraftApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
