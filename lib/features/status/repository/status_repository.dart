import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:chat_app/common/repository/common_firebase_strorage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/select_contact/controller/select_contact_controller.dart';
import 'package:chat_app/model/status_model.dart';
import 'package:chat_app/model/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required BuildContext context,
    required String username,
    required String profilePicture,
    required String phoneNumber,
    required File statusImage,
  }) async {
    try {
      bool isOpen = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          isOpen = true;
          return AlertDialog(
            title: const Text("Uploading Status..."),
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
      String statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      List<String> statusImageUrls = [];
      List<String> whoCanSeeId = [auth.currentUser!.uid];

      String imageDownloadUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref: "status/$statusId$uid",
            file: statusImage,
          );

      ref.watch(getContactsProvider).whenData((value) async {
        for (Contact contact in value) {
          for (int i = 0; i < contact.phones.length; i++) {
            var contactData = await firestore
                .collection("users")
                .where(
                  "phoneNumber",
                  isEqualTo: contact.phones[i].number.replaceAll(" ", ""),
                )
                .get();
            if (contactData.docs.isNotEmpty && contactData.docs[0].exists) {
              var userData = UserModel.fromMap(contactData.docs[0].data());
              whoCanSeeId.add(userData.uid);
            }
          }
        }
      });
      var statusSnapshot = await firestore
          .collection("status")
          .where("uid", isEqualTo: auth.currentUser!.uid)
          .get();
      if (statusSnapshot.docs.isNotEmpty && statusSnapshot.docs[0].exists) {
        StatusModel status = StatusModel.fromMap(statusSnapshot.docs[0].data());
        statusImageUrls = status.photoUrls;
        statusImageUrls.add(imageDownloadUrl);
        await firestore
            .collection("status")
            .doc(statusSnapshot.docs[0].id)
            .update({
          "photoUrls": statusImageUrls,
        });
      } else {
        statusImageUrls.add(imageDownloadUrl);
        StatusModel status = StatusModel(
          uid: uid,
          phoneNumber: phoneNumber,
          username: username,
          photoUrls: statusImageUrls,
          createdAt: DateTime.now(),
          profilePicture: profilePicture,
          statusId: statusId,
          whoCanSee: whoCanSeeId,
        );
        await firestore.collection("status").doc(statusId).set(status.toMap());
      }
      if (isOpen) {
        Navigator.pop(context);
      }
      Navigator.pop(context);
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  Future<List<StatusModel>> getStatus({
    required BuildContext context,
  }) async {
    List<StatusModel> allStatus = [];
    List<Contact> allContacts = [];
    // List<UserModel> allUsers = [];
    try {
      List<StatusModel> allFirebaseStatus = [];

      var myStatus = await firestore
          .collection("status")
          .where("uid", isEqualTo: auth.currentUser!.uid)
          .where(
            "createdAt",
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();

      if (myStatus.docs.isNotEmpty) {
        for (var statusData in myStatus.docs) {
          StatusModel status = StatusModel.fromMap(statusData.data());
          allStatus.add(status);
        }
      }

      var allFirebaseStatusData = await firestore
          .collection("status")
          .where(
            "createdAt",
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .where("whoCanSee", arrayContains: auth.currentUser!.uid)
          .get();

      if (allFirebaseStatusData.docs.isNotEmpty) {
        for (int i = 0; i < allFirebaseStatusData.docs.length; i++) {
          StatusModel status =
              StatusModel.fromMap(allFirebaseStatusData.docs[i].data());
          if (status.uid != auth.currentUser!.uid) {
            allFirebaseStatus.add(status);
          }
        }
      }

      if (await FlutterContacts.requestPermission()) {
        allContacts = await FlutterContacts.getContacts(withProperties: true);
      }
      // var allFirebaseUsers = await firestore
      //     .collection("users")
      //     .where("uid", isNotEqualTo: auth.currentUser!.uid)
      //     .get();
      //
      // if (allFirebaseUsers.docs.isNotEmpty) {
      //   for (int i = 0; i < allFirebaseUsers.docs.length; i++) {
      //     UserModel user = UserModel.fromMap(allFirebaseUsers.docs[i].data());
      //     allUsers.add(user);
      //   }
      // }
      for (var i = 0; i < allContacts.length; i++) {
        for (int j = 0; j < allContacts[i].phones.length; j++) {
          for (int x = 0; x < allFirebaseStatus.length; x++) {
            if (allContacts[i].phones[j].number.replaceAll(" ", "") ==
                allFirebaseStatus[x].phoneNumber) {
              allStatus.add(allFirebaseStatus[x]);
            }
          }
        }
      }

      // ref.watch(getContactsProvider).whenData((value) async {
      //   for (Contact contact in value) {
      //     for (int i = 0; i < contact.phones.length; i++) {
      //       for (int j = 0; j < allFirebaseStatus.length; j++) {
      //         if (contact.phones[i].number.replaceAll(" ", "") ==
      //             allFirebaseStatus[j].phoneNumber) {
      //           allStatus.add(allFirebaseStatus[j]);
      //         }
      //       }
      //     }
      //   }
      // });
    } catch (error) {
      print(error.toString());
      showSnackBar(context: context, content: error.toString());
    }
    return allStatus;
  }
}
