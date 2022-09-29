import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/common/providers/message_replay_provider.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/features/chat/widgets/my_message_card.dart';
import 'package:chat_app/features/chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;

  const ChatList({
    Key? key,
    required this.receiverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  void messageReplay({
    required String message,
    required String senderName,
    required bool isMe,
    required MessageType messageType,
  }) {
    ref.read(messageReplayProvider.state).update(
          (state) => MessageReplayModel(
            message: message,
            isMe: isMe,
            messageType: messageType,
            senderName: senderName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: widget.isGroupChat
            ? ref
                .watch(chatControllerProvider)
                .getGroupMessages(widget.receiverUserId)
            : ref
                .watch(chatControllerProvider)
                .getChatMessages(widget.receiverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandel();
          }
          // scroll to last message
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              MessageModel message = snapshot.data![index];

              if (!widget.isGroupChat &&
                  !message.isSeen &&
                  message.receiverId ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                      context: context,
                      receiverUserId: widget.receiverUserId,
                      messageId: message.id,
                    );
              }
              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.text,
                  date: DateFormat('hh:mm a').format(message.sentTime),
                  messageType: message.type,
                  repliedMessage: message.repliedMessage,
                  repliedTo: message.repliedTo,
                  repliedMessageType: message.repliedMessageType,
                  onLeftSwipe: () => messageReplay(
                    message: message.text,
                    isMe: true,
                    messageType: message.type,
                    senderName: message.senderName,
                  ),
                  isSeen: message.isSeen,
                );
              } else {
                return SenderMessageCard(
                  message: message.text,
                  date: DateFormat('hh:mm a').format(message.sentTime),
                  messageType: message.type,
                  repliedMessage: message.repliedMessage,
                  username: message.repliedTo,
                  repliedMessageType: message.repliedMessageType,
                  onRightSwipe: () => messageReplay(
                    message: message.text,
                    isMe: false,
                    messageType: message.type,
                    senderName: message.senderName,
                  ),
                );
              }
            },
          );
        });
  }
}
