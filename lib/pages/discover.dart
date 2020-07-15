import 'dart:async';
import 'dart:convert';

import 'package:bhezo/Impos/connectivity.dart';
import 'package:bhezo/Impos/selected.dart';
import 'package:bhezo/pages/location.dart';
import 'package:bhezo/pages/recieve.dart';
import 'package:bhezo/pages/send.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:bhezo/utils/mywid.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p/gen/protos/protos.pb.dart';
import 'package:flutter_p2p/flutter_p2p.dart';

class Discover extends StatefulWidget {
  final String wayToGo;
  final Selections selection;
  const Discover({@required this.wayToGo, @required this.selection});
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _deviceAddress = "";
  var _isConnected = false;
  var _isHost = false;
  var _isOpen = false;
  bool wifiState = false;
  Alignment wifiBtnAlignment = Alignment.centerLeft;

  P2pSocket _socket;
  List<WifiP2pDevice> devices = [];
  List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    // Set Wifi State
    print("Discover Says ${widget.selection.allSelections}");
    Reciever().getWifiStatus().then((value) {
      setState(() {
        wifiState = value;
      });
    });
    Timer(Duration(seconds: 1), () {
      if (!_isConnected && wifiState) {
        print("Discovering");
        FlutterP2p.discoverDevices();
      }
    });
    super.initState();
    _register();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _register();
  //   } else if (state == AppLifecycleState.paused) {
  //     _unregister();
  //   }
  // }

  void _register() async {
    if (!await _checkPermission()) {
      return;
    }
    _subscriptions.add(FlutterP2p.wifiEvents.stateChange.listen((change) {
      print("stateChange: ${change.isEnabled}");
    }));
    _subscriptions.add(FlutterP2p.wifiEvents.connectionChange.listen((change) {
      setState(() {
        _isConnected = change.networkInfo.isConnected;
        _isHost = change.wifiP2pInfo.isGroupOwner;
        _deviceAddress = change.wifiP2pInfo.groupOwnerAddress;
      });
      print(
          "connectionChange: ${change.wifiP2pInfo.isGroupOwner}, Connected: ${change.networkInfo.isConnected}");
      if (_isConnected) {
        if (widget.wayToGo == "SEND") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Send(
                    selections: widget.selection,
                    isHost: _isHost,
                    subscription: _subscriptions,
                    deviceAddress: _deviceAddress,
                  )));
        }
        if (widget.wayToGo == "RECIEVE") {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  Recieve(deviceAddress: _deviceAddress, isHost: _isHost)));
        }
      }
    }));
    _subscriptions.add(FlutterP2p.wifiEvents.thisDeviceChange.listen((change) {
      print(
          "deviceChange: ${change.deviceName} / ${change.deviceAddress} / ${change.primaryDeviceType} / ${change.secondaryDeviceType} ${change.isGroupOwner ? 'GO' : '-GO'}");
    }));
    _subscriptions.add(FlutterP2p.wifiEvents.discoveryChange.listen((change) {
      print("discoveryStateChange: ${change.isDiscovering}");
    }));
    _subscriptions.add(FlutterP2p.wifiEvents.peersChange.listen((change) {
      setState(() {
        devices = change.devices;
      });
    }));
    FlutterP2p.register();
  }

  // void _unregister() {
  //   _subscriptions.forEach((subscription) => subscription.cancel());
  //   FlutterP2p.unregister();
  // }

  // _connectToPort(int port) async {
  //   var socket = await FlutterP2p.connectToHost(
  //     _deviceAddress,
  //     port,
  //     timeout: 100000,
  //   );
  //   setState(() {
  //     _socket = socket;
  //   });
  //   _socket.inputStream.listen((data) {
  //     var msg = utf8.decode(data.data);
  //     snackBar("Received from ${_isHost ? "Host" : "Client"} $msg");
  //   });
  //   print("_connectToPort done");
  // }

  Future<bool> _checkPermission() async {
    if (!await FlutterP2p.isLocationPermissionGranted()) {
      await FlutterP2p.requestLocationPermission();
      return false;
    }
    return true;
  }

  Future<bool> _disconnect() async {
    bool result = await FlutterP2p.removeGroup();
    _socket = null;
    if (result) _isOpen = false;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: width,
        height: height,
        color: ThemeAssets().lightAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Discover",
              style: ThemeAssets().titleBlack,
            ),
            SizedBox(height: 5),
            Text(
              "Please enable WIFI to connect to device\nand start sharing",
              style: ThemeAssets().subtitleBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 100,
              width: width,
              child: Center(
                child: AnimatedContainer(
                  width: 110,
                  height: 50,
                  alignment:
                      !wifiState ? Alignment.centerLeft : Alignment.centerRight,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.bounceOut,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    child: CircleAvatar(
                      backgroundColor: ThemeAssets().darkAccent,
                      child: IconButton(
                          icon: Icon(
                            !wifiState ? Icons.signal_wifi_off : Icons.wifi,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Reciever().changeWifiStatus().then((value) {
                              print(value);
                              setState(() {
                                wifiState = !wifiState;
                              });
                            });
                          }),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width * 0.8,
              height: height * 0.4,
              child: wifiState
                  ? Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: width * 0.4,
                                  height: width * 0.4,
                                  child: FlareActor(
                                    'assets/Connecting_Ripple.flr',
                                    animation: 'Untitled',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 5),
                                RawMaterialButton(
                                    fillColor: ThemeAssets().darkAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Scan Devices"),
                                    ),
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      if (wifiState == true && !_isConnected) {
                                        print("Discovering");
                                        FlutterP2p.discoverDevices();
                                      }
                                    })
                              ],
                            ),
                          ),
                          devices.length > 0
                              ? ListView(
                                  shrinkWrap: true,
                                  children: this.devices.map((d) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 30,
                                            child: IconButton(
                                                icon: Icon(Icons.android),
                                                onPressed: () {
                                                  FlutterP2p.connect(d);
                                                }),
                                          ),
                                          SizedBox(height: 2),
                                          Container(
                                              color: ThemeAssets().lightAccent,
                                              padding: EdgeInsets.all(5),
                                              child: Text(d.deviceName))
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Container(),
                        ],
                      ),
                    )
                  : Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          child: FlareActor(
                            'assets/NO_Wifi.flr',
                            animation: 'init',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: height * 0.05),
            Text("Tap on the required device to connect")
          ],
        ),
      ),
    );
  }

  snackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// onTap: () {
// print(
// "${_isConnected ? "Disconnect" : "Connect"} to device: $_deviceAddress");
// return _isConnected
// ? FlutterP2p.cancelConnect(d)
// : FlutterP2p.connect(d);
// },
