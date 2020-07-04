import 'dart:async';

import 'package:bhezo/pages/home.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  final String title;
  Welcome({@required this.title});
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  Future<bool> firstRun() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool first = sp.getBool("first");
    if (first == null) {
      sp.setBool("first", true);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    firstRun().then((value) => {
          if (value)
            {
              Timer(Duration(seconds: 2), () {
                //Ask for Permissions.. and If Wants to see the tour
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                      pageBuilder: (a, b, c) {
                        return Home();
                      },
                      transitionDuration: Duration(seconds: 1)),
                );
              })
            }
          else
            {
              Timer(Duration(seconds: 2), () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                      pageBuilder: (a, b, c) {
                        return Home();
                      },
                      transitionDuration: Duration(seconds: 1)),
                );
              })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  key: Key("LogoHero"),
                  tag: "LogoHero",
                  child: Container(
                    width: width * 0.7,
                    height: width * 0.7,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/BLogo.png"))),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.greenAccent[200]),
                ),
              ],
            ),
            Positioned(
                bottom: 20,
                child: Text(
                  "Made in India",
                  style: ThemeAssets().subtitle,
                ))
          ]),
    );
  }
}
