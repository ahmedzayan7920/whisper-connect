import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/status/repository/status_repository.dart';
import 'package:chat_app/model/status_model.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void uploadStatus({
    required BuildContext context,
    required File statusImage,
  }) async {
    ref.watch(userDataAuthProvider).whenData((value) {
      ref.read(statusRepositoryProvider).uploadStatus(
            context: context,
            username: value!.name,
            profilePicture: value.profilePicture,
            phoneNumber: value.phoneNumber,
            statusImage: statusImage,
          );
    });
  }

  Future<List<StatusModel>> getStatus({
    required BuildContext context,
  }) async {
    return await statusRepository.getStatus(context: context);
  }
}
