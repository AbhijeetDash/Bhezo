import 'package:flutter/services.dart';

class DevicePictures{
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  static Future<Object> get getPictures async {
    Map<dynamic,dynamic> object = await platform.invokeMethod('getPictures');
    return object;
  }
}