import 'package:bhezo/utils/mywid.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height - 160,
      width: width - 10,
      child: FutureBuilder(
        future: DeviceApps.getInstalledApplications(
            includeAppIcons: true,
            includeSystemApps: false,
            onlyAppsWithLaunchIntent: true),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = snapshot.data;
            return GridView.builder(
              itemCount: apps.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,),
              itemBuilder: (context, position) {
                Application app = apps[position];
                String name = "";
                if(app.appName.length > 10){
                  name = app.appName.substring(0,9)+"...";
                } else {
                  name = app.appName;
                }
                return Column(
                  children: <Widget>[
                    CustomAppCard(
                        width: width,
                        app: app,
                        name: name,
                        icon: app is ApplicationWithIcon ? app.icon : null,),
                  ],
                );
              });
          }
        },
      ),
    );
  }
}
