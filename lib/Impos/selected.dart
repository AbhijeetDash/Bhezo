import 'dart:ui';

import 'package:bhezo/utils/getterFile.dart';
import 'package:bhezo/utils/getterMusic.dart';
import 'package:bhezo/utils/getterVideos.dart';
import 'package:device_apps/device_apps.dart';

class Selections {
  final List<Map<String, Object>> allSelections = [];
  final List<String> checkList = [];

  void addToSelections(Map<String, Object> path) {
    allSelections.add(path);
    if (path.containsKey('Application')) {
      Application app = path['Application'];
      checkList.add(app.apkFilePath);
    }
    if (path.containsKey('Song')) {
      Song song = path['Song'];
      checkList.add(song.fullPath);
    }
    if (path.containsKey('Video')) {
      Video video = path['Video'];
      checkList.add(video.fullPath);
    }
    if (path.containsKey('File')) {
      MyFile file = path['File'];
      checkList.add(file.filePath);
    }
    if (path.containsKey('Image')) {
      String pic = path['Image'];
      checkList.add(pic);
    }
  }

  void removeFromSelections(Map<String, Object> path) {
    allSelections.remove(path);
    if (path.containsKey('Application')) {
      Application app = path['Application'];
      checkList.remove(app.apkFilePath);
    }
    if (path.containsKey('Song')) {
      Song song = path['Song'];
      checkList.remove(song.fullPath);
    }
    if (path.containsKey('Video')) {
      Video video = path['Video'];
      checkList.remove(video.fullPath);
    }
    if (path.containsKey('File')) {
      MyFile file = path['File'];
      checkList.remove(file.filePath);
    }
    if (path.containsKey('Image')) {
      String pic = path['Image'];
      checkList.remove(pic);
    }
  }

  bool contains(Map<String, Object> path) {
    if (path.containsKey('Application')) {
      Application app = path['Application'];
      return checkList.contains(app.apkFilePath);
    }
    if (path.containsKey('Song')) {
      Song song = path['Song'];
      return checkList.contains(song.fullPath);
    }
    if (path.containsKey('Video')) {
      Video video = path['Video'];
      return checkList.contains(video.fullPath);
    }
    if (path.containsKey('File')) {
      MyFile file = path['File'];
      return checkList.contains(file.filePath);
    }
    if (path.containsKey('Image')) {
      String pic = path['Image'];
      return checkList.contains(pic);
    }
  }
}

//Make a Transfer class to call platform code to transfer file at a particular path;
