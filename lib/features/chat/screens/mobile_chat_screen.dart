import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/features/call/screens/call_pickup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = "/mobile_chat_screen";

  final String uid;
  final String name;
  final String profilePicture;
  final bool isGroupChat;

  const MobileChatScreen({
    Key? key,
    required this.uid,
    required this.name,
    required this.profilePicture,
    required this.isGroupChat,
  }) : super(key: key);

  startVideoCall({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ref.read(callControllerProvider).startCall(
          context: context,
          receiverId: uid,
          receiverName: name,
          receiverPicture: profilePicture,
          isGroupChat: isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(profilePicture),
              ),
              const SizedBox(width: 10),
              isGroupChat
                  ? Text(name)
                  : StreamBuilder<UserModel>(
                      stream: ref
                          .read(authControllerProvider)
                          .userDataById(userId: uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(name);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name),
                            Text(
                              snapshot.data!.isOnline ? "online" : "offline",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => startVideoCall(context: context, ref: ref),
              icon: const Icon(Icons.video_call),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(
                receiverUserId: uid,
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatField(
              receiverUserId: uid,
              receiverName: name,
              isGroupChat: isGroupChat,
            ),
          ],
        ),
      ),
    );
  }
}
