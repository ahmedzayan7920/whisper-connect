import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:chat_app/common/repository/common_firebase_strorage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/model/group_model.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String groupName,
    required File? groupPicture,
    required List<Contact> groupContacts,
  }) async {
    try {
      String groupPictureUrl = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
      String groupId = const Uuid().v1();
      List<String> uIds = [];
      for (int i = 0; i < groupContacts.length; i++) {
        var userData = await firestore
            .collection("users")
            .where(
              "phoneNumber",
              isEqualTo:
                  groupContacts[i].phones[0].number.replaceAll(" ", ""),
            )
            .get();
        if (userData.docs.isNotEmpty && userData.docs[0].exists) {
          uIds.add(userData.docs[0].data()["uid"]);
        }
      }
      if (groupPicture != null){
        groupPictureUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(ref: "group/$groupId", file: groupPicture);
      }


      GroupModel group = GroupModel(
        senderId: auth.currentUser!.uid,
        groupName: groupName,
        groupId: groupId,
        groupLastMessage: "Group Created.",
        groupPicture: groupPictureUrl,
        groupMembers: [auth.currentUser!.uid, ...uIds],
        sentTime: DateTime.now(),
      );
      await firestore.collection("groups").doc(groupId).set(group.toMap());
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
