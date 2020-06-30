
import 'dart:convert';

import 'package:flutter/services.dart';

class DeviceVideo {
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  static Future<List<Video>> getVideo() async {
    return platform.invokeMethod('getVideo').then((videos) {
      List<Video> list = new List();
      if (videos != null && videos is List) {
        for(var element in videos){
          if(element is Map){
            try {
              list.add(Video(element));
            } catch (e) {
              if (e is AssertionError) {
                print('[DeviceVideo] Unable to add the following file: $element');
              } else {
                print('[DeviceVideo] $e');
              }
            }
          }
        }
        return list;
      } else {
        return list;
      }
    }).catchError((onError) {
      print(onError);
      return List<Video>(0);
    });
  }
}

class Video {
  final String videoName;
  final String fullPath;
  final String duration;

  factory Video(Map map) {
    if (map.containsKey('thumbnail')) {
      return VideoWithIcon._fromMap(map);
    } else {
      return Video._fromMap(map);
    }
  }

  Video._fromMap(Map map)
    :assert(map["videoName"] != null),
     assert(map["fullPath"] != null),
     assert(map["duration"] != null),
     videoName = map["videoName"],
     fullPath = map["fullPath"],
     duration = map["duration"];
     
}

class VideoWithIcon extends Video{
  final String _icon;

  VideoWithIcon._fromMap(Map map)
      : assert(map['app_icon'] != null),
        _icon = map['app_icon'],
        super._fromMap(map);

  get icon => base64.decode(_icon);
}