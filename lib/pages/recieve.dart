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
  List<Widget> recieved = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  P2pSocket _socket;

  Future<void> writeFile(Uint8List data) async {
    getExternalStorageDirectory().then((dir) {
      String path = dir.path;
      print(path);
      File f = File("$path/base.apk");
      f.writeAsBytes(data);
    });
  }

  void connectAndRecieve(int port) async {
    if (widget.isHost) {
      var socket = await FlutterP2p.openHostPort(port);
      setState(() {
        _socket = socket;
      });
      Uint8List dd;
      socket.inputStream.listen((event) {
        dd += event.data;
        if (!event.hasData()) {
          print("\nNO DATA saving\n");
          writeFile(dd);
        }
      });
      FlutterP2p.acceptPort(port);
    } else {
      var socket = await FlutterP2p.connectToHost(
        widget.deviceAddress, // see above `Connect to a device`
        port,
      );
      var msg = "";
      socket.inputStream.listen((event) {
        msg += "${event.data}";
        if (!event.hasData()) {
          print("\nNO DATA saving\n");
        }
      });
    }
  }

  @override
  void initState() {
    connectAndRecieve(8888);
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
          alignment: Alignment.center,
          child: Text("Nothing to recieve")),
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
