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
  final isHost;
  final Selections selections;
  final String deviceAddress;
  const Send(
      {Key key,
      @required this.isHost,
      @required this.deviceAddress,
      @required this.subscription,
      @required this.selections})
      : super(key: key);
  @override
  _SendState createState() => _SendState();
}

class _SendState extends State<Send> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isOpen = false;
  P2pSocket _socket;

  Future<void> sendFile(Map<String, Object> element) {
    try {
      Application app = element['Application'];
      File file = File(app.apkFilePath);
      file.openRead().forEach((element) {
        Uint8List dd = Uint8List.fromList(element);
        _socket.writeString("Application");
        _socket.writeString(app.appName);
        if (app is ApplicationWithIcon) {
          _socket.write(app.icon);
        }
        _socket.write(dd);
      });
    } catch (e) {
      print(e);
    }
  }

  void openAndAccept(int port) async {
    if (widget.isHost) {
      var socket = await FlutterP2p.openHostPort(port);
      setState(() {
        _socket = socket;
      });

      widget.selections.allSelections.forEach((element) {
        sendFile(element);
      });
    } else {
      var socket = await FlutterP2p.connectToHost(
        widget.deviceAddress, // see above `Connect to a device`
        port,
      );
      setState(() {
        _socket = socket;
      });

      widget.selections.allSelections.forEach((element) {
        sendFile(element);
      });
    }
  }

  @override
  void initState() {
    openAndAccept(8888);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ThemeAssets().lightAccent,
        leading: IconButton(icon: Icon(Icons.close), onPressed: () {}),
        title: Text("Sending"),
        centerTitle: true,
      ),
      body: Container(
        width: width,
        height: height,
        color: ThemeAssets().lightAccent,
        alignment: Alignment.center,
        child: Container(
          height: height * 0.9,
          child: ListView.builder(
              itemCount: widget.selections.allSelections.length,
              itemBuilder: (context, i) {
                try {
                  Application app =
                      widget.selections.allSelections[i]['Application'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: app is ApplicationWithIcon
                              ? MemoryImage(app.icon)
                              : Icon(Icons.android),
                        ),
                        title: Text(
                          app.appName,
                          style: ThemeAssets().titleBlack,
                        ),
                        subtitle: Text(app.dataDir),
                        //trailing: CircularProgressIndicator(),
                      ),
                      Divider()
                    ],
                  );
                } catch (e) {}
                try {
                  Song music = widget.selections.allSelections[i]['Song'];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.music_note),
                        ),
                        title: Text(
                          music.songName,
                          style: ThemeAssets().titleBlack,
                        ),
                        subtitle: Text(music.artistName),
                        //trailing: CircularProgressIndicator(),
                      ),
                      Divider()
                    ],
                  );
                } catch (e) {}
                try {
                  Video video = widget.selections.allSelections[i]['Video'];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.music_note),
                        ),
                        title: Text(
                          video.videoName,
                          style: ThemeAssets().titleBlack,
                        ),
                        subtitle: Text(video.fullPath),
                        //trailing: CircularProgressIndicator(),
                      ),
                      Divider()
                    ],
                  );
                } catch (e) {}
                try {
                  File image =
                      File(widget.selections.allSelections[i]['Image']);
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(image),
                        ),
                        title: Text(
                          image.path.substring(
                              image.path.lastIndexOf("/"), image.path.length),
                          style: ThemeAssets().titleBlack,
                        ),
                        subtitle: Text(image.path),
                        //trailing: CircularProgressIndicator(),
                      ),
                      Divider()
                    ],
                  );
                } catch (e) {}
                try {
                  MyFile myFile = widget.selections.allSelections[i]['File'];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: myFile.isDirectory
                              ? Icon(Icons.folder)
                              : Icon(Icons.insert_drive_file),
                        ),
                        title: Text(
                          myFile.fileName,
                          style: ThemeAssets().titleBlack,
                        ),
                        subtitle: Text(myFile.filePath),
                        //trailing: CircularProgressIndicator(),
                      )
                    ],
                  );
                } catch (e) {}
                return Center(
                    child: Text(
                  "Nothing to send",
                  style: ThemeAssets().subtitleBlack,
                  textAlign: TextAlign.center,
                ));
              }),
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
