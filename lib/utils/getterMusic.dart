
import 'dart:convert';

import 'package:flutter/services.dart';

class DeviceMusic {
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  static Future<List<Song>> getMusic() async {
    return platform.invokeMethod('getMusic').then((musics) {
      List<Song> list = new List();
      if (musics != null && musics is List) {
        for(var element in musics){
          if(element is Map){
            try {
              list.add(Song(element));
            } catch (e) {
              if (e is AssertionError) {
                print('[DeviceMusic] Unable to add the following file: $element');
              } else {
                print('[DeviceMusic] $e');
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
      return List<Song>(0);
    });
  }
}

class Song {
  final String songName;
  final String fullPath;
  final String albumName;
  final String artistName;

  factory Song(Map map) {
    if (map.containsKey('thumbnail')) {
      return SongWithIcon._fromMap(map);
    } else {
      return Song._fromMap(map);
    }
  }

  Song._fromMap(Map map)
    :assert(map["songName"] != null),
     assert(map["fullPath"] != null),
     assert(map["albumName"] != null),
     assert(map["artistName"] != null),
     songName = map["songName"],
     fullPath = map["fullPath"],
     albumName = map["albumName"],
     artistName = map["artistName"];
     
}

class SongWithIcon extends Song{
  final String _icon;

  SongWithIcon._fromMap(Map map)
      : assert(map['app_icon'] != null),
        _icon = map['app_icon'],
        super._fromMap(map);

  get icon => base64.decode(_icon);
}