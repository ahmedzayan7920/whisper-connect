import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:chat_app/model/group_model.dart';

class GroupsList extends ConsumerWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<GroupModel>>(
        stream: ref.watch(chatControllerProvider).getChatGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandel();
          }
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              GroupModel chatGroup = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MobileChatScreen.routeName,
                    arguments: {
                      "name": chatGroup.groupName,
                      "uid": chatGroup.groupId,
                      "profilePicture": chatGroup.groupPicture,
                      "isGroupChat": true,
                    },
                  );
                },
                title: Text(
                  chatGroup.groupName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    chatGroup.groupLastMessage,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    chatGroup.groupPicture,
                  ),
                  radius: 30,
                ),
                trailing: Text(
                  DateFormat('hh:mm a').format(chatGroup.sentTime),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(color: dividerColor, indent: 85),
          );
        },
      ),
    );
  }
}
