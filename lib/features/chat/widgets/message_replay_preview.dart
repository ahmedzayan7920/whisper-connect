import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/providers/message_replay_provider.dart';
import 'package:chat_app/features/chat/widgets/display_message_types.dart';

class MessageReplayPreview extends ConsumerWidget {
  final String receiverName;
  const MessageReplayPreview({Key? key, required this.receiverName}) : super(key: key);

  void cancelReplay(WidgetRef ref) {
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MessageReplayModel? messageReplay = ref.watch(messageReplayProvider);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(right: 55),
      decoration: const BoxDecoration(
        color: mobileChatBoxColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration:  BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageReplay!.isMe ? "You" : receiverName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                DisplayMessageTypes(
                  message: messageReplay.message,
                  messageType: messageReplay.messageType,
                  isReplay: true,
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => cancelReplay(ref),
              child: const Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
