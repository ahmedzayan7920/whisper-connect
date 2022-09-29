import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final bool isReplay;

  const VideoPlayerItem({Key? key, required this.videoUrl, required this.isReplay}) : super(key: key);

  @override
  State<VideoPlayerItem> createState() => _CachedVideoPlayerItemState();
}

class _CachedVideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    videoController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoController.setVolume(1);
        videoController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isReplay ? 160 : 320,
      height: widget.isReplay ? 90 : 180,
      child: AspectRatio(
        aspectRatio: 16/9,
        child: Stack(
          children: [
            CachedVideoPlayer(videoController),
            Center(
              child: IconButton(
                onPressed: () {
                  if (isPlaying) {
                    videoController.pause();
                    isPlaying = false;
                  } else {
                    videoController.play();
                    isPlaying = true;
                  }
                  setState(() {});
                },
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
