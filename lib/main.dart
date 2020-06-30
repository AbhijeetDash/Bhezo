import 'package:bhezo/pages/welcome.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrow',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: ThemeAssets().primary
      ),
      home: Welcome(title: 'Arrow'),
      debugShowCheckedModeBanner: false,
    );
  }
}
