import 'dart:io';
import 'dart:typed_data';
import 'package:bhezo/utils/getterFile.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p/flutter_p2p.dart';

class Recieve extends StatefulWidget {
  final String deviceAddress;
  const Recieve({Key key, this.deviceAddress}) : super(key: key);
  @override
  _RecieveState createState() => _RecieveState();
}

class _RecieveState extends State<Recieve> {
  Uint8List data;
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
    socket.inputStream.listen((event) {
      addBytes(event.data);
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
      ),
    );
  }
}
