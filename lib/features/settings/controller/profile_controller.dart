import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/settings/repository/profile_repository.dart';

final profileControllerProvider = Provider((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return ProfileController(profileRepository: profileRepository, ref: ref);
});

class ProfileController {
  final ProfileRepository profileRepository;
  final ProviderRef ref;

  ProfileController({
    required this.profileRepository,
    required this.ref,
  });

  void updateUserDataToFirebase({
    required BuildContext context,
    required String name,
    required String about,
    required File? profilePicture,
  }) async {
    profileRepository.updateUserDataToFirebase(
      context: context,
      ref: ref,
      name: name,
      about: about,
      profilePicture: profilePicture,
    );
  }
}
