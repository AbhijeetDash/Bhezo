import 'dart:async';

import 'package:bhezo/Impos/connectivity.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:flutter/material.dart';

class LocationEnabler extends StatefulWidget {
  @override
  _LocationEnablerState createState() => _LocationEnablerState();
}

class _LocationEnablerState extends State<LocationEnabler> {
  bool locationStatus = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: ThemeAssets().lightAccent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Location",
              style: ThemeAssets().titleBlack,
            ),
            SizedBox(height: 5),
            Text(
              "Please enable location\nit is needded to be\nable to connect",
              style: ThemeAssets().subtitleBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 30,
              child: IconButton(
                  icon: locationStatus
                      ? Icon(Icons.location_on)
                      : Icon(Icons.location_off),
                  onPressed: () {
                    Sender().startLocation().then((value) {
                      print("hello $value");
                      Sender().getLocationStatus().then((location) {
                        if (location) {
                          setState(() {
                            locationStatus = location;
                          });
                        }
                        Navigator.of(context).pop();
                      });
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
