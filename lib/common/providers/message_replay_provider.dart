import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/enums/message_type.dart';

class MessageReplayModel {
  final String message;
  final bool isMe;
  final MessageType messageType;
  final String senderName;

  MessageReplayModel({
    required this.message,
    required this.isMe,
    required this.messageType,
    required this.senderName,
  });
}

final messageReplayProvider = StateProvider<MessageReplayModel?>((ref) => null);
