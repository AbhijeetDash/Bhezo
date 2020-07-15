import 'dart:async';
import 'dart:typed_data';

import 'package:bhezo/Impos/connectivity.dart';
import 'package:bhezo/Impos/selected.dart';
import 'package:bhezo/pages/discover.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:bhezo/utils/deco.dart';

Selections selections = new Selections();

class AnimatedOptions extends StatefulWidget {
  final double wid;
  const AnimatedOptions({Key key, @required this.wid}) : super(key: key);

  @override
  _AnimatedOptionsState createState() => _AnimatedOptionsState();
}

class _AnimatedOptionsState extends State<AnimatedOptions> {
  Color backgroundColor;
  double width = 100;
  double height = 40;
  Widget childWidgetButton, optionList;
  bool wid = false, wid2 = false;

  @override
  void initState() {
    childWidgetButton = Center(
      child: CircleAvatar(
        radius: 20,
        backgroundColor: ThemeAssets().darkAccent,
        child: IconButton(
          onPressed: () {
            setState(() {
              wid = true;
              Timer(Duration(milliseconds: 20), () {
                setState(() {
                  wid2 = true;
                });
              });
            });
          },
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
      ),
    );

    optionList = Padding(
      padding: EdgeInsets.only(top: 20, right: 10),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: ThemeAssets().darkAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 8),
            Expanded(
                flex: 1,
                child: FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {},
                    child: Text(
                      "PC Share",
                      style: ThemeAssets().subtitle,
                    ))),
            Expanded(
                flex: 1,
                child: FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {},
                    child: Text(
                      "History",
                      style: ThemeAssets().subtitle,
                    ))),
            Expanded(
                flex: 1,
                child: FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {},
                    child: Text(
                      "Share our App",
                      style: ThemeAssets().subtitle,
                    ))),
            Expanded(
                flex: 1,
                child: FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {},
                    child: Text(
                      "Settings",
                      style: ThemeAssets().subtitle,
                    ))),
            Expanded(
                flex: 1,
                child: FlatButton(
                    shape: StadiumBorder(),
                    onPressed: () {
                      showAboutDialog(
                          context: context,
                          applicationIcon: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/BLogo.png'))),
                          ),
                          applicationName: "Bhezo",
                          applicationLegalese: "Incube Inc.");
                    },
                    child: Text(
                      "About us",
                      style: ThemeAssets().subtitleWhite,
                    ))),
            Expanded(
              flex: 1,
              child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      wid = false;
                      Timer(Duration(milliseconds: 300), () {
                        setState(() {
                          wid2 = false;
                        });
                      });
                    });
                  }),
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: wid ? Curves.elasticOut : Curves.elasticIn,
        width: wid ? 200 : widget.wid * 0.2,
        height: wid ? 300 : widget.wid * 0.2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: wid2 ? optionList : childWidgetButton);
  }
}

class CustomAppCard extends StatefulWidget {
  CustomAppCard({
    Key key,
    @required this.width,
    @required this.app,
    @required this.icon,
    @required this.name,
  }) : super(key: key);

  final double width;
  final Application app;
  final Uint8List icon;
  final String name;

  @override
  _CustomAppCardState createState() => _CustomAppCardState();
}

class _CustomAppCardState extends State<CustomAppCard> {
  bool selected;

  @override
  initState() {
    setState(() {
      if (selections.contains({"Application": widget.app})) {
        selected = true;
      } else {
        selected = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        if (selected) {
          selections.removeFromSelections({"Application": widget.app});
          setState(() {
            selected = false;
          });
        } else {
          showDialog(
              context: context,
              child: Dialog(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Associated Folder",
                          style: ThemeAssets().titlePage,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "/storage/emulated/0/${widget.app.packageName}",
                          style: ThemeAssets().subtitle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Only share if it's Important",
                          style: ThemeAssets().subtitleBlack,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              shape: StadiumBorder(),
                              fillColor: ThemeAssets().darkAccent,
                              child: Text("Cancle"),
                            ),
                            SizedBox(width: 10),
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              shape: StadiumBorder(),
                              fillColor: ThemeAssets().darkAccent,
                              child: Text("Share"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
          setState(() {
            selected = true;
          });
          selections.addToSelections({"Application": widget.app});
          print(selections.allSelections);
        }
      },
      child: Container(
          width: widget.width / 4,
          decoration: BoxDecoration(
              color: selected ? ThemeAssets().darkAccent : null,
              borderRadius: BorderRadius.circular(20)),
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                CircleAvatar(
                    radius: 15,
                    backgroundImage: widget.app is ApplicationWithIcon
                        ? MemoryImage(widget.icon)
                        : null),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, wordSpacing: 0.5),
                  ),
                ),
                SizedBox(
                  height: 10,
                  width: 10,
                  child: CircleAvatar(
                    backgroundColor: selected
                        ? ThemeAssets().darkAccent
                        : ThemeAssets().lightAccent,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          )),
    );
  }
}

class FolderSelector extends StatefulWidget {
  final Map<String, Object> path;
  const FolderSelector({Key key, @required this.path}) : super(key: key);
  @override
  _FolderSelectorState createState() => _FolderSelectorState();
}

class _FolderSelectorState extends State<FolderSelector> {
  bool selected;
  @override
  void initState() {
    if (selections.contains(widget.path)) {
      selected = true;
    } else {
      selected = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        setState(() {
          if (selected) {
            selected = false;
            selections.removeFromSelections(widget.path);
          } else {
            selected = true;
            selections.addToSelections(widget.path);
          }
        });
      },
      child: Container(
        child: CircleAvatar(
          maxRadius: 10,
          backgroundColor:
              selected ? ThemeAssets().darkAccent : ThemeAssets().lightAccent,
          child: Container(),
        ),
      ),
    );
  }
}

class SendRecieveButton extends StatelessWidget {
  const SendRecieveButton({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 5),
          RawMaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (a, b, c) {
                    return Discover(
                      wayToGo: "SEND",
                      selection: selections,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500)));
            },
            shape: StadiumBorder(),
            fillColor: ThemeAssets().darkAccent,
            child: Text("Send"),
          ),
          SizedBox(width: 5),
          RawMaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                  pageBuilder: (a, b, c) {
                    return Discover(
                      wayToGo: "RECIEVE",
                      selection: selections,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500)));
            },
            shape: StadiumBorder(),
            fillColor: ThemeAssets().darkAccent,
            child: Text("Recieve"),
          ),
        ],
      ),
    );
  }
}
