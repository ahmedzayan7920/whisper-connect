import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/home/screens/search_screen.dart';
import 'package:chat_app/features/select_contact/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerStatefulWidget {
  static const String routeName = "/select_contacts_screen";

  const SelectContactsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactsScreen> createState() =>
      _SelectContactsScreenState();
}

class _SelectContactsScreenState extends ConsumerState<SelectContactsScreen> {
  void selectContact({
    required BuildContext context,
    required WidgetRef ref,
    required Contact selectedContact,
  }) {
    ref.read(selectContactControllerProvider).selectContact(
          selectedContact: selectedContact,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select contact"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
            icon: const Icon(Icons.search_outlined),
          ),
          IconButton(
            onPressed: () {
              ref.refresh(getContactsProvider);
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: ref.watch(getContactsProvider).when(
              data: (contactList) => ListView.separated(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  var contact = contactList[index];
                  return ListTile(
                    onTap: () => selectContact(
                      context: context,
                      ref: ref,
                      selectedContact: contact,
                    ),
                    title: Text(contact.displayName),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: contact.photo == null
                          ? const NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                            )
                          : MemoryImage(contact.photo!) as ImageProvider,
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
              ),
              error: (error, stackTrace) {
                return ErrorHandel(error: error.toString());
              },
              loading: () => const LoadingHandel(),
            ),
      ),
    );
  }
}
