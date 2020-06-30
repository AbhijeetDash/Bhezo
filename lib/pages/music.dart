import 'package:bhezo/utils/mywid.dart';
import 'package:bhezo/utils/deco.dart';
import 'package:bhezo/utils/getterMusic.dart';
import 'package:flutter/material.dart';

class Music extends StatefulWidget {
  @override
  _MusicState createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height - 160,
      width: width - 10,
      child: FutureBuilder(
        future: DeviceMusic.getMusic(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Song> songs = snapshot.data;
            if(songs.length == 0){
              return Center(child: Text("No Music Found"),);
            }
            return Container(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context,i){
                  Song song = songs[i];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(child: Icon(Icons.music_note)),
                        title: Text(song.songName, style: ThemeAssets().subtitleBlack,),
                        subtitle: Text("Artist: ${song.artistName}", style: ThemeAssets().subtitleBlack,),
                        trailing: FolderSelector(path: {"Song":songs[i]}),
                      ),
                      Divider()
                    ],
                  );
                }
              )
            );
          }
        },
      ),
    );
  }
}