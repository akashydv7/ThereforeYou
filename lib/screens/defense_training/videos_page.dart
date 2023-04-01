import 'package:first/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:first/screens/defense_training/video_data.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../shared/loading.dart';

class TrainingVideoPage extends StatefulWidget {
  const TrainingVideoPage({super.key});

  @override
  State<TrainingVideoPage> createState() => _TrainingVideoPageState();
}

class _TrainingVideoPageState extends State<TrainingVideoPage> {
  
  List<Widget> video = [];
  Widget createContainer(String url, String title, context){
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: false,
        disableDragSeek: false,
        isLive: false,
        forceHD: false ));
      return Container(
            margin: EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * .3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      ),
                    child: YoutubePlayer(
                    controller: _controller,
                    liveUIColor: Colors.grey,),
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }
  void getUrls(context){
    setState(() {
      
    YoutubeVideo.url.forEach((key, value) {
      video.add(createContainer(key, value, context));
      }
    );
    });
  }
  @override
  Widget build(BuildContext context) {
    getUrls(context);
    return video==[]?Loading():Scaffold(
      appBar: AppBar(title: Text("Defense Training Video"), backgroundColor: gunmetal),
      backgroundColor: white2,
      body: ListView.builder(
        itemCount: video.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              video[index],
              SizedBox(height: 10,)
            ],
          );
        }
    ));
  }
}