import 'dart:async';

import 'package:bhezo/pages/apps.dart';
import 'package:bhezo/pages/music.dart';
import 'package:bhezo/pages/others.dart';
import 'package:bhezo/pages/pictures.dart';
import 'package:bhezo/pages/videos.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:bhezo/utils/getterPicture.dart';
import 'package:bhezo/utils/mywid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedIndex = 0;
  bool hide = false;
  List<String> titles = <String>[
    "Apps","Music","Videos","Pictures","Others"
  ];
  List<Widget> options = <Widget>[
    Apps(),
    Music(),
    Videos(),
    Images(),
    Others()
  ];

  void _onItemSelected(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    Timer(Duration(seconds: 5), (){
      setState(() {
        hide = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
    ]);
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.android, color: ThemeAssets().darkAccent,),
            title: Text("Apps", style: ThemeAssets().subtitleBlack,)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note, color: ThemeAssets().darkAccent,),
            title: Text("Music", style: ThemeAssets().subtitleBlack)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie, color: ThemeAssets().darkAccent,),
            title: Text("Videos", style: ThemeAssets().subtitleBlack)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image, color: ThemeAssets().darkAccent,),
            title: Text("Pictures", style: ThemeAssets().subtitleBlack)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder, color: ThemeAssets().darkAccent),
            title: Text("Others", style: ThemeAssets().subtitleBlack)
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onItemSelected,
        selectedItemColor: ThemeAssets().darkAccent,
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
                bottom: -width * 0.25,
                left: -width * 0.25,
                child: CircleAvatar(
                  radius: width * 0.5,
                  backgroundColor: ThemeAssets().lightAccent.withOpacity(0.3),
                )),
            Positioned(
              top: 20,
              left: 10,
              child: Hero(
                key: Key("LogoHero"),
                tag: "LogoHero",
                child: Container(
                  width: width * 0.2,
                  height: width * 0.2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage("assets/BLogo.png"))),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: options[selectedIndex]
            ),
            Positioned(
              top: 20,
              left: width*0.5-width*0.1,
                child: Container(
                  width: width*0.2,
                  height: width*0.2,
                  alignment: Alignment.center,
                  child: Text(titles[selectedIndex], style: ThemeAssets().titlePage,)),
            ),
            Positioned(
                top: 20,
                right: 0,
                child: AnimatedOptions(wid: width,)),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if(details.primaryVelocity.sign > 0.0){
                  if(selectedIndex >= 1){
                    setState(() {
                      selectedIndex--;
                    });
                  }
                } else {
                  if(selectedIndex < 4){
                    setState(() {
                      selectedIndex++;
                    });
                  }
                }
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SendRecieveButton(width: width)
            )
          ],
        ),
      ),
    );
  }
}
