import 'package:bhezo/Impos/connectivity.dart';
import 'package:bhezo/pages/scanCam.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flare_dart/actor.dart';
import 'package:wifi_flutter/wifi_flutter.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  bool wifiState = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        color: ThemeAssets().lightAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 28.0, bottom: 5),
              child: Hero(
                  tag: "DiscoverPage",
                  key: Key("DiscoverPage"),
                  child: Text(
                    "Discover",
                    style: ThemeAssets().titleBlack,
                  )),
            ),
            Text(
              "Turn your wifi ON and\nfind nearby device to connect",
              style: ThemeAssets().subtitleBlack,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: FutureBuilder(
                future: Reciever().getWifiStatus(),
                builder: (context, snap) {
                  if (snap.data == null) {
                    return Center(child: Text("Getting wifi Status"));
                  } else {
                    wifiState = snap.data;
                    return WifiButton(wifiState: wifiState);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WifiButton extends StatefulWidget {
  WifiButton({Key key, @required this.wifiState}) : super(key: key);
  bool wifiState = false;
  @override
  _WifiButtonState createState() => _WifiButtonState();
}

class _WifiButtonState extends State<WifiButton> {
  Alignment btnAlign = Alignment.centerLeft;
  Widget icon = Icon(Icons.signal_wifi_off);
  bool localBool = false;

  bool nameBool = false;
  Widget name;

  Future<void> scanWifi() async {
    // final net = await WifiFlutter.wifiNetworks;
    // net.forEach((element) {
    //   if (element.ssid.contains("AndroidShare")) {
    //     print("found");
    //     setState(() {
    //       name = Text(
    //         element.ssid + "\nTap to connect",
    //         style: ThemeAssets().subtitleBlack,
    //         textAlign: TextAlign.center,
    //       );
    //       nameBool = true;
    //     });
    //     return;
    //   }
    // });
    return await WifiFlutter.scanNetworks().then((value) {
      final networks = value;
      networks.forEach((element) {
        print("searching");
        if (element.ssid.contains("AndroidShare")) {
          print("found");
          setState(() {
            name = Text(
              element.ssid + "\nTap to connect",
              style: ThemeAssets().subtitleBlack,
              textAlign: TextAlign.center,
            );
            nameBool = true;
          });
          return;
        }
      });
      return;
    });
  }

  @override
  void initState() {
    if (widget.wifiState) {
      scanWifi();
    }
    setState(() {
      localBool = widget.wifiState;
      if (widget.wifiState) {
        btnAlign = Alignment.centerRight;
        icon = Icon(Icons.wifi);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        AnimatedContainer(
          height: 60,
          width: 120,
          curve: Curves.bounceOut,
          duration: Duration(milliseconds: 200),
          alignment: btnAlign,
          decoration: BoxDecoration(
              color: ThemeAssets().darkAccent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: <BoxShadow>[
                BoxShadow(blurRadius: 15, spreadRadius: -5)
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              radius: 25,
              child: IconButton(
                  icon: icon,
                  onPressed: () {
                    Reciever().changeWifiStatus().then((value) {});
                    setState(() {
                      localBool = !localBool;
                      if (localBool) {
                        btnAlign = Alignment.centerRight;
                        icon = Icon(Icons.wifi);
                      } else {
                        btnAlign = Alignment.centerLeft;
                        icon = Icon(Icons.signal_wifi_off);
                        nameBool = false;
                      }
                    });
                    if (localBool == true) {
                      scanWifi();
                    }
                  }),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Container(
            width: width * 0.8,
            height: height * 0.4,
            child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: localBool
                        ? Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              FlareActor(
                                'assets/Connecting_Ripple.flr',
                                animation: "Untitled",
                              ),
                              nameBool == false
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundColor: ThemeAssets().darkAccent,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.crop_free,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CamScan()));
                                          }))
                                  : RawMaterialButton(
                                      shape: StadiumBorder(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                ThemeAssets().darkAccent,
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.crop_free,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CamScan()));
                                                }),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color:
                                                      ThemeAssets().darkAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(18.0),
                                                child: name,
                                              )),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CamScan()));
                                      },
                                    )
                            ],
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            child: FlareActor('assets/NO_Wifi.flr',
                                animation: "init")))),
          ),
        )
      ],
    );
  }
}
