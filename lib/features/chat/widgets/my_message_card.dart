import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/features/chat/widgets/display_message_types.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageType messageType;

  final Function() onLeftSwipe;
  final String repliedMessage;
  final String repliedTo;
  final MessageType repliedMessageType;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onLeftSwipe,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplaying = repliedMessage.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 320,
            minWidth: 120,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isReplaying)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repliedTo,
                            ),
                            DisplayMessageTypes(
                              message: repliedMessage,
                              messageType: repliedMessageType,
                              isReplay: true,
                            ),
                          ],
                        ),
                      ),
                    DisplayMessageTypes(
                      message: message,
                      messageType: messageType,
                      isReplay: false,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Spacer(),
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          isSeen ?Icons.done_all: Icons.done,
                          size: 20,
                          color: isSeen ? Colors.blue : Colors.white60,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
