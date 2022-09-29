import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/common/providers/message_replay_provider.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/chat/repository/chat_repository.dart';
import 'package:chat_app/model/chat_contact_model.dart';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/message_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<MessageModel>> getChatMessages(String receiverUserId) {
    return chatRepository.getChatMessages(receiverUserId);
  }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return chatRepository.getGroupMessages(groupId);
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required bool isGroupChat,
  }) {
    MessageReplayModel? messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverId: receiverUserId,
            senderUser: value!,
            messageReplay: messageReplay,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required MessageType messageType,
    required bool isGroupChat,
  }) {
    MessageReplayModel? messageReplay = ref.read(messageReplayProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverId: receiverUserId,
            senderUser: value!,
            ref: ref,
            messageType: messageType,
            messageReplay: messageReplay,
            isGroupChat: isGroupChat,
          ),
        );
    ref.read(messageReplayProvider.state).update((state) => null);
  }

// void sendGifMessage({
//   required BuildContext context,
//   required String gifUrl,
//   required String receiverUserId,
//   required bool isGroupChat,
// }) async {
//   int index = gifUrl.lastIndexOf("-") + 1;
//   String urlPart = gifUrl.substring(index);
//   String lastUrl = "https://i.giphy.com/media/$urlPart/200.gif";
//   ref.read(userDataAuthProvider).whenData(
//         (value) => chatRepository.sendGifMessage(
//           context: context,
//           gifUrl: lastUrl,
//           receiverUserId: receiverUserId,
//           senderUser: value!,
//   isGroupChat: isGroupChat,
//         ),
//       );
// }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) {
    chatRepository.setChatMessageSeen(
      context: context,
      receiverUserId: receiverUserId,
      messageId: messageId,
    );
  }
}
