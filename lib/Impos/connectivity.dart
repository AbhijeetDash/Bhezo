import 'dart:async';

import 'package:bhezo/Impos/selected.dart';
import 'package:flutter/services.dart';

class Reciever {
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  Future<bool> connectToWifi() async {
    return await platform.invokeMethod("connectToWifi").then((value) {
      return value;
    });
  }

  Future<bool> getWifiStatus() {
    return platform
        .invokeMethod('getWifiStatus')
        .then((value) => value is bool ? value : true);
  }

  Future<bool> changeWifiStatus() {
    return platform
        .invokeMethod("changeWifiState")
        .then((value) => value is bool ? value : true);
  }

  Future<Wifi> scanWifi() {
    return platform.invokeMethod("scanWifi").then((value) {
      return Wifi(value);
    });
  }

  Future<bool> connectToServer(String ip, int port) {
    // Takes The IP Address and Port Number
  }

  Future<bool> startRecieve() {}
}

class Wifi {
  final String ssid;

  factory Wifi(Map map) {
    return Wifi._fromMap(map);
  }

  Wifi._fromMap(Map map)
      : assert(map["file_name"] != null),
        ssid = map['isDir'];
}

class Sender {
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  // Code to Start the server and get Details;
  Future<bool> startServer() {
    // Starts the server and sets the WAP variable on platform channel;
    return platform.invokeMethod("startServer").then((value) => value);
  }

  Future<String> getCodeDetails() async {
    // Uses the WAp variable to get the details;
    return await platform.invokeMethod("getCodeDetails").then((value) {
      if (value is String) {
        return value;
      }
    });
  }

  // Code to Send Files;
  Future<bool> sendFile(Selections selection) {}

  // Code to Handle location status;
  Future<bool> startLocation() {
    return platform.invokeMethod("enableLocation");
  }

  Future<bool> getLocationStatus() {
    return platform.invokeMethod("getLocationStatus").then((value) => value);
  }
}
