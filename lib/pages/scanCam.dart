import 'package:bhezo/utils/deco.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CamScan extends StatefulWidget {
  @override
  _CamScanState createState() => _CamScanState();
}

class _CamScanState extends State<CamScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      List<String> details = scanData.split("\n");
      showDialog(
          context: context,
          child: SizedBox(
            width: 200,
            height: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Found",
                    style: ThemeAssets().titleBlack,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: details.length,
                      itemBuilder: (builder, i) {
                        return Text(
                          details[i],
                          style: ThemeAssets().subtitleBlack,
                          textAlign: TextAlign.center,
                        );
                      }),
                  SizedBox(height: 5),
                  Text("connecting"),
                  SizedBox(height: 5),
                  Center(child: CircularProgressIndicator())
                ],
              ),
            ),
          ));
      // call the connect function
      controller.pauseCamera();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
