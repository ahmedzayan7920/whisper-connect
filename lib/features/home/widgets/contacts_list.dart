import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:chat_app/model/chat_contact_model.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContactModel>>(
        stream: ref.watch(chatControllerProvider).getChatContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandel();
          }
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ChatContactModel chatContact = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    MobileChatScreen.routeName,
                    arguments: {
                      "name": chatContact.name,
                      "uid": chatContact.uid,
                      "profilePicture": chatContact.profilePicture,
                      "isGroupChat": false,
                    },
                  );
                },
                title: Text(
                  chatContact.name,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    chatContact.lastMessage,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    chatContact.profilePicture,
                  ),
                  radius: 30,
                ),
                trailing: Text(
                  DateFormat('hh:mm a').format(chatContact.sentTime),
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
