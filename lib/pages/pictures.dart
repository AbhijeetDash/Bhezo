import 'dart:io';
import 'package:bhezo/utils/deco.dart';
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
            builder: (context, snap) {
              if (snap.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                this.allImage = snap.data['URIList'] as List;
                this.allNameList = snap.data['DISPLAY_NAME'] as List;
                if (allImage.length == 0) {
                  return Center(child: Text("No Pictures"));
                }
                return ListView.builder(
                    itemCount: allImage.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: FileImage(File(allImage[i]))),
                            title: Text(allNameList[i]),
                            subtitle: Text(allImage[i]),
                            trailing: FolderSelector(
                              path: {"Image": allImage[i]},
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  child: Dialog(
                                    backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                                    child: Container(
                                      width: width * 0.8,
                                      height: height * 0.6,
                                      child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Stack(
                                          fit: StackFit.passthrough,
                                          children: <Widget>[
                                            Container(
                                              width: width * 0.8,
                                              height: height * 0.6,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  image: DecorationImage(
                                                      image: FileImage(
                                                          File(allImage[i])),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: RawMaterialButton(
                                                    elevation: 5,
                                                    shape: StadiumBorder(),
                                                    fillColor: ThemeAssets()
                                                        .darkAccent,
                                                    child: Text(
                                                      "Done",
                                                      style: ThemeAssets()
                                                          .subtitleBlack,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    }))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                          Divider()
                        ],
                      );
                    });
              }
            }));
  }
}
