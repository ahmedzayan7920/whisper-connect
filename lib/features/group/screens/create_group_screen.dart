import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/colors.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/group/controller/group_controller.dart';
import 'package:chat_app/features/group/widgets/select_group_contacts.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = "/create_group_screen";

  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    ref.read(selectedGroupContacts.state).state.length;
    if (groupNameController.text.trim().isNotEmpty && ref.read(selectedGroupContacts.state).state.isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context: context,
            groupName: groupNameController.text.trim(),
            groupPicture: image,
            groupContacts: ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.state).update((state) => []);
    }else{
      showSnackBar(context: context, content: "Fill out all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  image == null
                      ? const CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                          ),
                          radius: 64,
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 64,
                        ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            TextFormField(
              controller: groupNameController,
              decoration: const InputDecoration(
                hintText: "Enter Group Name",
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Select Contacts",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SelectGroupContacts(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
