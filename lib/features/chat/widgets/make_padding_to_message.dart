import 'package:flutter/material.dart';
import 'package:chat_app/common/enums/message_type.dart';

class MakePaddingToMessage extends StatelessWidget {
  final MessageType type;
  final Widget widget;

  const MakePaddingToMessage(
      {Key? key, required this.type, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageType.text
        ? Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 30,
              top: 5,
            ),
            child: widget,
          )
        : type == MessageType.image
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 5,
                ),
                child: widget,
              )
            : type == MessageType.video
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 5,
                    ),
                    child: widget,
                  )
                : type == MessageType.gif
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                        ),
                        child: widget,
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                        ),
                        child: widget,
                      );
  }
}
