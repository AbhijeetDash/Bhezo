import 'package:bhezo/Impos/selected.dart';
import 'package:flutter/services.dart';

class Reciever{
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');
  
  Future<bool> getWifiStatus(){
    return platform.invokeMethod('getWifiStatus').then((value) => value is bool?value:true);
  }

  Future<bool> changeWifiStatus(){
    return platform.invokeMethod("changeWifiState").then((value) => value is bool?value:true);
  }

  Future<bool> connectToServer(String ip, int port){
    // Takes The IP Address and Port Number
  }

  Future<bool> startRecieve(){

  }
}

class Sender{
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  Future<bool> startServer(){
    return platform.invokeMethod("startServer").then((value) => value);
  }

  Future<bool> startLocation(){
    return platform.invokeMethod("enableLocation");
  }

  Future<bool> getLocationStatus(){
    return platform.invokeMethod("getLocationStatus").then((value) => value);
  }

  Future<bool> sendFile(Selections selection){

  }
}

