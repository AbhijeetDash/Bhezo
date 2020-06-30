import 'package:flutter/material.dart';

class ThemeAssets{
  Color primary = Color.fromRGBO(87, 203, 171, 1);
  Color primaryShadow = Color.fromRGBO(220, 230, 167, 1);
  Color lightAccent = Color.fromRGBO(154,223,176,1);
  Color darkAccent = Color.fromRGBO(236, 157, 117, 1);

  TextStyle subtitle = TextStyle(fontFamily: "Lato", color: Colors.grey, fontSize: 14, decoration: TextDecoration.none);
  TextStyle subtitleWhite = TextStyle(fontFamily: "lato", color: Colors.white, fontSize: 14, decoration: TextDecoration.none);
  TextStyle subtitleBlack = TextStyle(fontFamily: "lato", color: Colors.black, fontSize: 14, decoration: TextDecoration.none);

  TextStyle titleBlack = TextStyle(fontFamily: "Lato", fontWeight: FontWeight.bold, fontSize: 18, decoration: TextDecoration.none);
  TextStyle titlePage = TextStyle(fontFamily: "Lato", fontWeight: FontWeight.bold, fontSize: 22, decoration: TextDecoration.none);
}