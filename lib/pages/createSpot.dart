import 'dart:async';

import 'package:bhezo/Impos/connectivity.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HotSpot extends StatefulWidget {
  @override
  _HotSpotState createState() => _HotSpotState();
}

class _HotSpotState extends State<HotSpot> {
  bool location = false;
  bool qrCode = false;
  Widget iconLocation = Icon(Icons.location_off);

  @override
  void initState() {
    Sender().getLocationStatus().then((value) {
      if (value == false) {
        showDialog(
            context: context,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      "Location",
                      style: ThemeAssets().titleBlack,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please enable location to\ncontinue. It improves sharing speed",
                      style: ThemeAssets().subtitleBlack,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    CircleAvatar(
                      radius: 30,
                      child: IconButton(
                          icon: iconLocation,
                          onPressed: () {
                            Sender().startLocation().then((val) {
                              if (Navigator.canPop(context)) {
                                Navigator.of(context).pop(this);
                              }
                            });
                          }),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )).then((value) {
          initState();
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop(this);
          }
        });
      } else {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(this);
        }
        setState(() {
          location = value;
        });
        Timer(Duration(seconds: 1), () {
          setState(() {
            qrCode = true;
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          color: ThemeAssets().lightAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // First Future Builder to Start Location..
              location
                  ? FutureBuilder(
                      future: Sender().startServer(),
                      builder: (context, snap) {
                        if (snap.data == null) {
                          Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        bool a = snap.data;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Server Started",
                                style: ThemeAssets().titleBlack),
                            SizedBox(height: 5),
                            Text(
                              "The server is up and runing\nPlease ask the reciever to Scan\nthe QR-Code",
                              style: ThemeAssets().subtitleBlack,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: width * 0.7,
                              child: qrCode
                                  ? FutureBuilder(
                                      future: Sender().getCodeDetails(),
                                      builder: (context, snap) {
                                        if (snap.data != null) {
                                          String data = snap.data;
                                          List<String> ipPort =
                                              data.split("...");
                                          String ip = ipPort[0];
                                          return Column(
                                            children: <Widget>[
                                              QrImage(
                                                data: data,
                                                backgroundColor:
                                                    ThemeAssets().lightAccent,
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                data,
                                                style:
                                                    ThemeAssets().subtitleBlack,
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          );
                                        }
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "generating qr-code",
                                          style: ThemeAssets().subtitleBlack,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                            child: CircularProgressIndicator())
                                      ],
                                    ),
                            )
                          ],
                        );
                      })
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Please Enable Location",
                            style: ThemeAssets().titleBlack,
                            textAlign: TextAlign.center),
                        SizedBox(height: 5),
                        Text(
                            "Location is required to\nincrease the transfer speed\nKnow More..")
                      ],
                    )
              // Second to Start..
            ],
          )),
    );
  }
}
