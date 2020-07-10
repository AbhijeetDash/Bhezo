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
  @override
  void initState() {
    super.initState();
  }

  void startRecieve(int port) async {
    var socket = await FlutterP2p.connectToHost(
      widget.deviceAddress,
      port,
      timeout: 100000,
    );
    socket.inputStream.listen((event) {
      var msg = "";
      msg += String.fromCharCodes(event.data);
      if (event.dataAvailable == 0) {
        showDialog(
            context: context,
            child: Card(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Text(msg),
              ),
            ));
      }
      // if (event.hasData()) {
      //   setState(() {
      //     // Update UI;
      //   });
      // }
      // File.fromUri(Uri.parse("../")).writeAsBytes(event.data);
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
