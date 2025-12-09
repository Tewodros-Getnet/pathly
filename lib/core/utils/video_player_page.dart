import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt_mobile;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt_web;

class VideoPlayerPage extends StatefulWidget {
  final String url;
  final String title;

  const VideoPlayerPage({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final String videoId;

  yt_mobile.YoutubePlayerController? mobileController;
  yt_web.YoutubePlayerController? webController;

  @override
  void initState() {
    super.initState();

    videoId = extractYoutubeId(widget.url);

    if (kIsWeb) {
      /// WEB CONTROLLER
      webController = yt_web.YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: const yt_web.YoutubePlayerParams(
          showFullscreenButton: true,
          playsInline: true,
        ),
      );
    } else {
      /// MOBILE CONTROLLER
      mobileController = yt_mobile.YoutubePlayerController(
        initialVideoId: videoId,
        flags: const yt_mobile.YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.white, backgroundColor: Colors.blue),

      body: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// --- VIDEO FIXED AT TOP ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: kIsWeb
                  ? yt_web.YoutubePlayerScaffold(
                controller: webController!,
                builder: (context, player) => player,
              )
                  : yt_mobile.YoutubePlayer(
                controller: mobileController!,
                showVideoProgressIndicator: true,
              ),
            ),
          ),

          const SizedBox(height: 7),

          /// --- CONTENT BELOW (SCROLLABLE) ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mobileController?.dispose();
    super.dispose();
  }
}

String extractYoutubeId(String url) {
  final RegExp regExp = RegExp(
    r"(?:v=|\/|shorts\/)([0-9A-Za-z_-]{11})",
    caseSensitive: false,
  );
  return regExp.firstMatch(url)?.group(1) ?? url;
}
