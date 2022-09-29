import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:chat_app/model/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getCurrentUserData() async{
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepository.signInWithPhone(
      context: context,
      phoneNumber: phoneNumber,
    );
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) {
    authRepository.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required String name,
    required String about,
    required File? profilePicture,
  }) {
    authRepository.saveUserDataToFirebase(
      context: context,
      ref: ref,
      name: name,
      about: about,
      profilePicture: profilePicture,
    );
  }

  Stream<UserModel> userDataById({required String userId}) {
    return authRepository.userDataById(userId: userId);
  }

  void updateUserState(bool isOnline){
    authRepository.updateUserState(isOnline);
  }
}
