import 'package:flutter/material.dart';

class Recieve extends StatefulWidget {
  @override
  _RecieveState createState() => _RecieveState();
}

class _RecieveState extends State<Recieve> {
  @override
  void initState() {
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
      ),
    );
  }
}
