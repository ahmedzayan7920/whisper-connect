import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/status/controller/status_controller.dart';
import 'package:chat_app/features/status/screens/status_screen.dart';
import 'package:chat_app/model/status_model.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<StatusModel>>(
      future: ref.read(statusControllerProvider).getStatus(context: context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingHandel();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              StatusModel status = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.pushNamed(context, StatusScreen.routeName,
                      arguments: status);
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    status.profilePicture,
                  ),
                  radius: 30,
                ),
                title: Text(
                  status.uid == FirebaseAuth.instance.currentUser!.uid
                      ? "My Status"
                      : status.username,
                ),
                subtitle: Text(
                  DateFormat('hh:mm a').format(status.createdAt),
                ),
                trailing: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  child: Text(
                    status.photoUrls.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) =>
                const Divider(color: dividerColor),
          ),
        );
      },
    );
  }
}
