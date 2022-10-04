import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  SelectContactRepository({
    required this.firestore,
    required this.auth,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> allContacts = [];
    List<UserModel> allUsers = [];
    List<Contact> appContacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        allContacts = await FlutterContacts.getContacts(withProperties: true);
      }
      var allFirebaseUsers = await firestore
          .collection("users")
          .where("uid", isNotEqualTo: auth.currentUser!.uid)
          .get();

      if (allFirebaseUsers.docs.isNotEmpty) {
        for (int i = 0; i < allFirebaseUsers.docs.length; i++) {
          UserModel user = UserModel.fromMap(allFirebaseUsers.docs[i].data());
          allUsers.add(user);
        }
      }
      for (var i = 0; i < allContacts.length; i++) {
        for (int j = 0; j < allContacts[i].phones.length; j++) {
          for (var k = 0; k < allUsers.length; k++) {
            if (allContacts[i].phones[j].number.replaceAll(" ", "") ==
                allUsers[k].phoneNumber) {
              appContacts.add(allContacts[i]);
            }
          }
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return appContacts;
  }

  void selectContact({
    required Contact selectedContact,
    required BuildContext context,
  }) async {
    try {
      var userData = await firestore
          .collection("users")
          .where("phoneNumber",
              isEqualTo: selectedContact.phones[0].number.replaceAll(" ", ""))
          .get();
      UserModel user = UserModel.fromMap(userData.docs[0].data());

      Navigator.pushReplacementNamed(context, MobileChatScreen.routeName,
          arguments: {
            "name": user.name,
            "uid": user.uid,
            "profilePicture": user.profilePicture,
            "isGroupChat": false,
          });
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
