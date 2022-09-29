import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/call/screens/call_screen.dart';
import 'package:chat_app/model/call_model.dart';
import 'package:chat_app/model/group_model.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection("calls").doc(auth.currentUser!.uid).snapshots();

  void startCall({
    required BuildContext context,
    required CallModel callerData,
    required CallModel receiverData,
  }) async {
    try {
      await firestore
          .collection("calls")
          .doc(callerData.callerId)
          .set(callerData.toMap());
      await firestore
          .collection("calls")
          .doc(callerData.receiverId)
          .set(receiverData.toMap());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: callerData.callId,
            call: callerData,
            isGroupChat: false,
          ),
        ),
      );
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void startGroupCall({
    required BuildContext context,
    required CallModel callerData,
    required CallModel receiverData,
  }) async {
    try {
      await firestore
          .collection("calls")
          .doc(callerData.callerId)
          .set(callerData.toMap());

      var groupData =
          await firestore.collection("groups").doc(callerData.receiverId).get();
      GroupModel group = GroupModel.fromMap(groupData.data()!);

      for (String id in group.groupMembers) {
        if (id != callerData.callerId) {
          await firestore.collection("calls").doc(id).set(receiverData.toMap());
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: callerData.callId,
            call: callerData,
            isGroupChat: true,
          ),
        ),
      );
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await firestore.collection("calls").doc(callerId).delete();
      await firestore.collection("calls").doc(receiverId).delete();
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void endGroupCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await firestore.collection("calls").doc(callerId).delete();
      var groupData =
      await firestore.collection("groups").doc(receiverId).get();
      GroupModel group = GroupModel.fromMap(groupData.data()!);

      for (String id in group.groupMembers) {
        if (id != callerId) {
          await firestore.collection("calls").doc(id).delete();
        }
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
