import 'dart:async';
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
    return platform.invokeMethod("changeWifiState").then((value) => value);
  }

  Future<Wifi> scanWifi() {
    return platform.invokeMethod("scanWifi").then((value) {
      return Wifi(value);
    });
  }
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

  // Code to Handle location status;
  Future<bool> startLocation() {
    return platform.invokeMethod("enableLocation").then((value) => value);
  }

  Future<bool> getLocationStatus() {
    return platform.invokeMethod("getLocationStatus").then((value) => value);
  }
}
