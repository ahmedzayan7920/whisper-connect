import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/call/repository/call_repository.dart';
import 'package:chat_app/model/call_model.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(callRepository: callRepository, ref: ref);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;

  CallController({
    required this.callRepository,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void startCall({
    required BuildContext context,
    required String receiverId,
    required String receiverName,
    required String receiverPicture,
    required bool isGroupChat,
  }) async {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      CallModel callerData = CallModel(
        callerId: value!.uid,
        callerName: value.name,
        callerPicture: value.profilePicture,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPicture: receiverPicture,
        callId: callId,
        hasDialled: true,
      );

      CallModel receiverData = CallModel(
        callerId: value.uid,
        callerName: value.name,
        callerPicture: value.profilePicture,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPicture: receiverPicture,
        callId: callId,
        hasDialled: false,
      );

      if (isGroupChat){
        callRepository.startGroupCall(
          context: context,
          callerData: callerData,
          receiverData: receiverData,
        );
      }else{
        callRepository.startCall(
          context: context,
          callerData: callerData,
          receiverData: receiverData,
        );
      }
    });
  }



  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    callRepository.endCall(
      context: context,
      callerId: callerId,
      receiverId: receiverId,
    );
  }
}
