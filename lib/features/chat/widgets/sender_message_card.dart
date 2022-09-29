import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/features/chat/widgets/display_message_types.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageType messageType;

  final Function() onRightSwipe;
  final String repliedMessage;
  final String username;
  final MessageType repliedMessageType;

  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onRightSwipe,
    required this.repliedMessage,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplaying = repliedMessage.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
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
            color: senderMessageColor,
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
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
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
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
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
