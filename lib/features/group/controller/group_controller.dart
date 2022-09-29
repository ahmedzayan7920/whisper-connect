import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(groupRepository: groupRepository, ref: ref);
});

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String groupName,
    required File? groupPicture,
    required List<Contact> groupContacts,
  }) {
    groupRepository.createGroup(
      context: context,
      groupName: groupName,
      groupPicture: groupPicture,
      groupContacts: groupContacts,
    );
  }
}
