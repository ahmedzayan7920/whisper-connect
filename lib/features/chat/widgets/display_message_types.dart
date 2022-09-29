import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/features/chat/widgets/video_player_item.dart';

class DisplayMessageTypes extends StatelessWidget {
  final String message;
  final MessageType messageType;
  final bool isReplay;

  const DisplayMessageTypes({
    Key? key,
    required this.message,
    required this.messageType,
    required this.isReplay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return messageType == MessageType.text
        ? isReplay
            ? ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 270,
                ),
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              )
            : Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                ),
              )
        : messageType == MessageType.image
            ? CachedNetworkImage(
                imageUrl: message,
                width: isReplay ? 160 : 320,
                height: isReplay ? 90 : 180,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            : messageType == MessageType.video
                ? VideoPlayerItem(videoUrl: message, isReplay: isReplay)
                : messageType == MessageType.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
      width: isReplay ? 160 : 320,
      height: isReplay ? 90 : 180,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: IconButton(
                              onPressed: () async {
                                if (isPlaying) {
                                  await audioPlayer.pause();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                } else {
                                  await audioPlayer.play(UrlSource(message));
                                  setState(() {
                                    isPlaying = true;
                                  });
                                }
                              },
                              icon: Center(
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  size: 40,
                                ),
                              ),
                            ),
                          );
                        },
                      );
  }
}
