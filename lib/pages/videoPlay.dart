import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VPlayer extends StatefulWidget {
  final String path;

  const VPlayer({@required this.path});

  @override
  _VPlayerState createState() => _VPlayerState();
}

class _VPlayerState extends State<VPlayer> {
  VideoPlayerController controller;
  bool playIcon = false;

  @override
  void initState() {
    controller = VideoPlayerController.file(File("${widget.path}"))
      ..initialize().then((value) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(widget.path
            .substring(widget.path.lastIndexOf("/") + 1, widget.path.length)
            .toUpperCase()),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Center(
              child: SizedBox(
                  height: height * 0.3,
                  width: width,
                  child: VideoPlayer(controller)),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      child: IconButton(
                          icon: playIcon
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              if (playIcon) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                              playIcon = !playIcon;
                            });
                          }),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
