import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/settings/controller/profile_controller.dart';
import 'package:chat_app/model/user_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = "/profile_screen";
  final UserModel user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  File? image;

  @override
  void initState() {
    nameController.text = widget.user.name;
    aboutController.text = widget.user.about;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    aboutController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void updateUserData() async {
    String name = nameController.text.trim();
    String about = aboutController.text.trim();
    if (name.isNotEmpty && about.isNotEmpty) {
      ref.read(profileControllerProvider).updateUserDataToFirebase(
            context: context,
            name: name,
            about: about,
            profilePicture: image,
          );
    } else {
      showSnackBar(context: context, content: "Fill out all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: updateUserData,
            icon: const Text(
              "Save",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  image == null
                      ? CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                            widget.user.profilePicture,
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
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: const Text(
                    "Name",
                    style: TextStyle(color: Colors.grey),
                  ),
                  hintText: "Enter your name",
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: aboutController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  label: const Text(
                    "About you",
                    style: TextStyle(color: Colors.grey),
                  ),
                  hintText: "About you",
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
