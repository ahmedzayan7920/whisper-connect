import 'package:chat_app/common/enums/message_type.dart';

class MessageModel {
  final String senderId;
  final String senderName;
  final String receiverId;
  final String text;
  final String id;
  final MessageType type;
  final DateTime sentTime;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageType repliedMessageType;

  MessageModel({
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.text,
    required this.id,
    required this.type,
    required this.sentTime,
    required this.isSeen,
    required this.repliedMessage,
    required this.repliedTo,
    required this.repliedMessageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'text': text,
      'type': type.type,
      'sentTime': sentTime.millisecondsSinceEpoch,
      'messageId': id,
      'isSeen': isSeen,
      'repliedMessage': repliedMessage,
      'repliedTo': repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toType(),
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime']),
      id: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      repliedMessage: map['repliedMessage'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).toType(),
      
    );
  }
}
