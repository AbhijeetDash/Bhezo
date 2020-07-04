import 'dart:io';

import 'package:bhezo/pages/videoPLay.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:bhezo/utils/getterVideos.dart';
import 'package:bhezo/utils/mywid.dart';
import 'package:flutter/material.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  String path = "Videos & Movies";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height - 160,
      alignment: Alignment.center,
      child: FutureBuilder(
          future: DeviceVideo.getVideo(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Video> videos = snapshot.data;
              if (videos.length == 0) {
                return Center(child: Text("No Videos Found"));
              }
              return ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, i) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading:
                              CircleAvatar(child: Icon(Icons.ondemand_video)),
                          title: Text(videos[i].videoName),
                          subtitle: Text((int.parse(videos[i].duration) / 3600)
                                  .toString()
                                  .substring(0, 3) +
                              " Min"),
                          trailing: FolderSelector(path: {"Video": videos[i]}),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    VPlayer(path: videos[i].fullPath)));
                          },
                        ),
                        Divider()
                      ],
                    );
                  });
            }
          }),
    );
  }
}
