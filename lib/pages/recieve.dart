import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bhezo/utils/getterFile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p/flutter_p2p.dart';

class Recieve extends StatefulWidget {
  final String deviceAddress;
  final isHost;
  const Recieve({Key key, @required this.deviceAddress, @required this.isHost})
      : super(key: key);
  @override
  _RecieveState createState() => _RecieveState();
}

class _RecieveState extends State<Recieve> {
  Uint8List data;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String fileType;
  String fileName;
  var icon;
  var fileLength;
  var index = 0;
  var widgets = <Widget>[];

  @override
  void initState() {
    super.initState();
  }

  void addBytes(Uint8List data) {
    data.forEach((element) {
      this.data.add(element);
    });
  }

  void startRecieve(int port) async {
    var socket = await FlutterP2p.connectToHost(
      widget.deviceAddress,
      port,
      timeout: 100000,
    );

    socket.inputStream.listen((event) async {
      if (index == 0) {
        fileType = String.fromCharCodes(event.data);
      }
      if (index == 1) {
        fileName = String.fromCharCodes(event.data);
      }
      if (index == 2) {
        icon = MemoryImage(event.data);
      }
      if (event.dataAvailable == 0 && index == 3) {
        widgets.add(ListTile(
          leading: Icon(icon),
          title: Text(fileName),
          subtitle: Text(fileType),
          trailing: Text(fileLength),
        ));
        addBytes(event.data);
      }
      if (event.dataAvailable == 0) {
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            child: StreamBuilder(
                stream: Stream.fromIterable(widgets),
                builder: (context, snap) {
                  return ListView.builder(itemBuilder: (context, i) {
                    return snap.data;
                  });
                })));
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
