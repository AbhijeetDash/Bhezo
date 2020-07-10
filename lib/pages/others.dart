import 'package:bhezo/utils/deco.dart';
import 'package:bhezo/utils/getterFile.dart';
import 'package:flutter/material.dart';
import 'package:bhezo/utils/mywid.dart';

class Others extends StatefulWidget {
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  bool gotData = false;
  bool pathChanged = false;
  String data = "hello";
  String path;
  ScrollController sc;

  void _updater(String path) {
    setState(() {
      this.path = path;
    });
  }

  String _getPreviousPath(String path) {
    int lt = path.lastIndexOf("/");
    return path.substring(0, lt);
  }

  @override
  void initState() {
    sc = new ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        color: Colors.white.withOpacity(0.8),
        width: width,
        height: height - 160,
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: sc,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      if (path != null && path != "/storage/emulated/0") {
                        _updater(_getPreviousPath(path));
                      }
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                  path != null
                      ? Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text(path.toUpperCase()))
                      : Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: Text("/STORAGE/EMULATED/0"))
                ],
              ),
            ),
            Container(
              height: height - 210,
              child: FutureBuilder(
                  future: path == null
                      ? DeviceFolders.getDeviceFiles()
                      : DeviceFolders.getFolderAtPath(path + "/"),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<MyFile> files = snapshot.data;
                      if (files.length <= 0) {
                        return Center(child: Text("Empty Folder"));
                      }
                      return ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, i) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: files[i].isDirectory
                                      ? Icon(Icons.folder_open)
                                      : Icon(Icons.insert_drive_file),
                                  title: Text(
                                    files[i].fileName,
                                    style: ThemeAssets().titleBlack,
                                  ),
                                  subtitle: Text(
                                    files[i].filePath,
                                    style: ThemeAssets().subtitle,
                                  ),
                                  onTap: () {
                                    if (files[i].isDirectory) {
                                      _updater(files[i].filePath);
                                    } else {
                                      showDialog(
                                          context: context,
                                          child: Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                padding: EdgeInsets.all(30),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      'Not a Directory',
                                                      style: ThemeAssets()
                                                          .titleBlack,
                                                    ),
                                                    SizedBox(height: 10),
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Okay"),
                                                      fillColor: ThemeAssets()
                                                          .darkAccent,
                                                      shape: StadiumBorder(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    }
                                  },
                                  trailing:
                                      FolderSelector(path: {"File": files[i]}),
                                ),
                                Divider(),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
