import 'dart:io';
import 'package:bhezo/utils/getterPicture.dart';
import 'package:bhezo/utils/mywid.dart';
import 'package:flutter/material.dart';

class Images extends StatefulWidget {
  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {

  List allImage = new List();
  List allNameList = new List();

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
      child: FutureBuilder(
        future: DevicePictures.getPictures,
        builder: (context, snap){
          if(snap.data == null){
            return Center(child: CircularProgressIndicator(),);
          } else {
            this.allImage = snap.data['URIList'] as List;
            this.allNameList = snap.data['DISPLAY_NAME'] as List;
            if(allImage.length == 0){
              return Center(child: Text("No Pictures"));
            }
            return  ListView.builder(
              itemCount: allImage.length,
              itemBuilder: (context, i){
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: FileImage(File(allImage[i]))
                      ),
                      title: Text(allNameList[i]),
                      subtitle: Text(allImage[i]),
                      trailing: FolderSelector(path: {"Image": allImage[i]},),
                    ),
                    Divider()
                  ],
                );
              });
          }
        })
    );
  }
}