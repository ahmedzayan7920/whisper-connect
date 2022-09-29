import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/repository/common_firebase_strorage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';

final profileRepositoryProvider = Provider(
      (ref) => ProfileRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  ),
);
class ProfileRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ProfileRepository({
    required this.auth,
    required this.firestore,
  });

  void updateUserDataToFirebase({
    required BuildContext context,
    required ProviderRef ref,
    required String name,
    required String about,
    required File? profilePicture,
  }) async {
    try {
      bool isOpen = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          isOpen = true;
          return AlertDialog(
            title: const Text("Sending Message..."),
            content: Row(
              children: const [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(width: 15),
                Text("Please wait")
              ],
            ),
          );
        },
      ).then((value) {
        isOpen = false;
      });
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";

      if (profilePicture != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
          ref: "profilePic/$uid",
          file: profilePicture,
        );
        await firestore.collection("users").doc(uid).update({
          "profilePic" : photoUrl,
          "name": name,
          "about": about,
        });
      }else{
        await firestore.collection("users").doc(uid).update({
          "name": name,
          "about": about,
        });
      }
      if (isOpen) {
        Navigator.pop(context);
      }
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}