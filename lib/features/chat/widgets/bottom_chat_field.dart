import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

// import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/common/providers/message_replay_provider.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/widgets/message_replay_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final String receiverName;
  final bool isGroupChat;

  const BottomChatField({
    Key? key,
    required this.receiverUserId,
    required this.receiverName,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  bool isEmoji = false;
  FocusNode focusNode = FocusNode();

  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic Permission Denied");
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sentTextMessage() async {
    if (isTyping) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: messageController.text.trim(),
            receiverUserId: widget.receiverUserId,
            isGroupChat: widget.isGroupChat,
          );
      setState(() {
        isTyping = false;
        messageController.text = "";
      });
    } else {
      var tempDirectory = await getTemporaryDirectory();
      String path = "${tempDirectory.path}/flutter_sound.aac";
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(
          file: File(path),
          messageType: MessageType.audio,
        );
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage({
    required File file,
    required MessageType messageType,
  }) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          file: file,
          receiverUserId: widget.receiverUserId,
          messageType: messageType,
          isGroupChat: widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(
        file: image,
        messageType: MessageType.image,
      );
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(
        file: video,
        messageType: MessageType.video,
      );
    }
  }

  // void selectGIF() async {
  //   GiphyGif? gif = await pickGIF(context);
  //   if (gif != null) {
  //     ref.read(chatControllerProvider).sendGifMessage(
  //           context: context,
  //           gifUrl: gif.url,
  //           receiverUserId: widget.receiverUserId,
  //         );
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    MessageReplayModel? messageReplay = ref.watch(messageReplayProvider);
    bool isShowMessageReplay = messageReplay != null;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isShowMessageReplay
              ?  MessageReplayPreview(receiverName: widget.receiverName)
              : const SizedBox.shrink(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: messageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: mobileChatBoxColor,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (isEmoji) {
                                focusNode.requestFocus();
                                isEmoji = false;
                              } else {
                                focusNode.unfocus();
                                isEmoji = true;
                              }
                              setState(() {});
                            },
                            child: Icon(
                              isEmoji
                                  ? Icons.keyboard_alt_outlined
                                  : Icons.emoji_emotions,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          // const SizedBox(width: 6),
                          // GestureDetector(
                          //   onTap: () {},
                          //   // onTap: selectGIF,
                          //   child: const Icon(
                          //     Icons.gif_box_outlined,
                          //     color: Colors.grey,
                          //     size: 30,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: selectImage,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: selectVideo,
                            child: const Icon(
                              Icons.video_collection_outlined,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: isShowMessageReplay
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )
                          : BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    // contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      isTyping = false;
                    } else {
                      isTyping = true;
                    }
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: sentTextMessage,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xff128c7e),
                  child: Icon(
                    isTyping
                        ? Icons.send_outlined
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          isEmoji
              ? SizedBox(
                  height: 310,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        messageController.text =
                            messageController.text + emoji.emoji;
                        isTyping = true;
                      });
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
