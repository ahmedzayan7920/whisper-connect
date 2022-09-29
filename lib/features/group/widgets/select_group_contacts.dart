import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/select_contact/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectGroupContacts extends ConsumerStatefulWidget {
  const SelectGroupContacts({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectGroupContacts> createState() =>
      _SelectGroupContactsState();
}

class _SelectGroupContactsState extends ConsumerState<SelectGroupContacts> {
  List<int> selectedContactIndex = [];

  void selectContact({
    required int index,
    required Contact contact,
  }) {
    if (selectedContactIndex.contains(index)) {
      selectedContactIndex.remove(index);
    } else {
      selectedContactIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (data) => Expanded(
            child: ListView.separated(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final contact = data[index];
                return CheckboxListTile(
                  title: Text(contact.displayName),
                  value: selectedContactIndex.contains(index),
                  onChanged: (bool? value) {
                    selectContact(contact: contact, index: index);
                  },
                  activeColor: Colors.blue,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 0),
            ),
          ),
          error: (error, stackTrace) => ErrorHandel(error: error.toString()),
          loading: () => const LoadingHandel(),
        );
  }
}
