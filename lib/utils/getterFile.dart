import 'dart:async';

import 'package:flutter/services.dart';

class DeviceFolders {
  static const platform = const MethodChannel('bhejo.flutter.dev/FUNCTIONS');

  static Future<List<File>> getDeviceFiles() async {
    return platform.invokeMethod('getFolders').then((files) {
      List<File> list = new List();
      if (files != null && files is List) {
        for(var element in files){
          if(element is Map){
            try {
              list.add(File(element));
            } catch (e) {
              if (e is AssertionError) {
                print('[DeviceFolders] Unable to add the following file: $element');
              } else {
                print('[DeviceFolders] $e');
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
      return List<File>(0);
    });
  }

    static Future<List<File>> getFolderAtPath(String path) async {
    return platform.invokeMethod('getFolderAtPath', {
      'path' : path
    }).then((files) {
      List<File> list = new List();
      if (files != null && files is List) {
        for(var element in files){
          if(element is Map){
            try {
              list.add(File(element));
            } catch (e) {
              if (e is AssertionError) {
                print('[DeviceFolders] Unable to add the following file: $element');
              } else {
                print('[DeviceFolders] $e');
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
      return List<File>(0);
    });
  }
}

class File {
  final String fileName;
  final String filePath;
  final bool isDirectory;

  factory File(Map map) {
    return File._fromMap(map);
  }

  File._fromMap(Map map)
      :assert(map["file_name"] != null),
       assert(map["file_path"] != null),
       assert(map['isDir'] != null),
       isDirectory = map['isDir'],
       fileName = map["file_name"],
       filePath = map["file_path"];
}