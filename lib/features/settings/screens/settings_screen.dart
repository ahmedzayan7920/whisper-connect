import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/features/settings/screens/profile_screen.dart';
import 'package:chat_app/features/settings/widgets/list_tile_item.dart';
import 'package:chat_app/model/user_model.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = "/settings_screen";

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserModel? user;

  @override
  void initState() {
    getUserInformation();
    super.initState();
  }

  getUserInformation() async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (userData.docs.isNotEmpty && userData.docs[0].exists) {
      user = UserModel.fromMap(userData.docs[0].data());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, ProfileScreen.routeName,
                                arguments: user)
                            .then((value) {
                          getUserInformation();
                          setState(() {});
                        });
                      },
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(user!.profilePicture),
                      ),
                      title: Text(user!.name),
                      subtitle: Text(user!.about),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: .001,
                    ),
                    ListTileItem(
                      leadingIconData: Icons.key_outlined,
                      title: "Account",
                      subtitle: "Privacy, security, change number",
                      onTap: () {},
                    ),
                    ListTileItem(
                      leadingIconData: Icons.chat_outlined,
                      title: "Chats",
                      subtitle: "Theme, wallpapers, chat history",
                      onTap: () {},
                    ),
                    ListTileItem(
                      leadingIconData: Icons.notifications_none_outlined,
                      title: "Notifications",
                      subtitle: "Message, group & call tones",
                      onTap: () {},
                    ),
                    ListTileItem(
                      leadingIconData: Icons.storage_outlined,
                      title: "Storage and data",
                      subtitle: "Network usage, auto-download",
                      onTap: () {},
                    ),
                    ListTileItem(
                      leadingIconData: Icons.help_outline,
                      title: "Help",
                      subtitle: "Help center, contact us, privacy policy",
                      onTap: () {},
                    ),
                    ListTileItem(
                      leadingIconData: Icons.groups_outlined,
                      title: "Invite a friend",
                      onTap: () {},
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("from"),
                        Text("♾ Meta"),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
