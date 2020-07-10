import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bhezo/Impos/selected.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:bhezo/utils/getterFile.dart';
import 'package:bhezo/utils/getterMusic.dart';
import 'package:bhezo/utils/getterVideos.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p/flutter_p2p.dart';

class Send extends StatefulWidget {
  final List<StreamSubscription> subscription;
  final Selections selections;
  const Send({Key key, @required this.subscription, @required this.selections})
      : super(key: key);
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isOpen = false;
  var _isHost = false;
  P2pSocket _socket;

  List<bool> listBool = [];

  Future<bool> progress() async {
    widget.selections.checkList.forEach((element) {
      listBool.add(false);
    });
    return true;
  }

  void sendData(int port) async {
    try {
      var socket = await FlutterP2p.openHostPort(port);
      setState(() {
        _socket = socket;
      });

      widget.selections.checkList.forEach((element) {
        socket.writeString("Hello World");
        // File data = File(element);
        // data.readAsBytes().then((value) {
        //   List<int> list = value;
        //   socket.write(list).then((value) {
        //     // Update the UI;
        //   });
        // });
      });
    } catch (e) {}
  }

  @override
  void initState() {
    progress().then((value) {
      if (value) {
        sendData(8888);
      }
    });
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
        child: ListView.builder(
            itemCount: widget.selections.allSelections.length,
            itemBuilder: (context, i) {
              if (widget.selections.allSelections[i]
                  .containsKey("Application")) {
                Application app =
                    widget.selections.allSelections[i]["Application"];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: app is ApplicationWithIcon
                        ? MemoryImage(app.icon)
                        : Icons.android,
                  ),
                  title: Text(app.appName, style: ThemeAssets().titleBlack),
                  subtitle: Text(
                    app.apkFilePath,
                    style: ThemeAssets().subtitle,
                  ),
                  trailing: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (widget.selections.allSelections[i].containsKey("Song")) {
                Song song = widget.selections.allSelections[i]["Song"];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ThemeAssets().darkAccent,
                    child: Icon(Icons.music_note),
                  ),
                  title: Text(song.songName, style: ThemeAssets().titleBlack),
                  subtitle: Text(
                    song.artistName,
                    style: ThemeAssets().subtitle,
                  ),
                  trailing: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (widget.selections.allSelections[i].containsKey("Video")) {
                Video video = widget.selections.allSelections[i]["Video"];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ThemeAssets().darkAccent,
                    child: Icon(Icons.movie),
                  ),
                  title: Text(video.videoName, style: ThemeAssets().titleBlack),
                  subtitle: Text(
                    video.duration,
                    style: ThemeAssets().subtitle,
                  ),
                  trailing: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (widget.selections.allSelections[i].containsKey("File")) {
                MyFile file = widget.selections.allSelections[i]["File"];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: ThemeAssets().darkAccent,
                    child: Icon(Icons.folder),
                  ),
                  title: Text(file.fileName, style: ThemeAssets().titleBlack),
                  subtitle: Text(
                    file.filePath,
                    style: ThemeAssets().subtitle,
                  ),
                  trailing: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (widget.selections.allSelections[i].containsKey("Image")) {
                String pic = widget.selections.allSelections[i]["Image"];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: FileImage(File(pic)),
                  ),
                  title: Text(pic.substring(pic.lastIndexOf("/"), pic.length),
                      style: ThemeAssets().titleBlack),
                  subtitle: Text(
                    pic,
                    style: ThemeAssets().subtitle,
                  ),
                  trailing: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
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
