import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loading.dart';
import 'package:chat_app/features/select_contact/controller/select_contact_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  static const String routeName = "/search_screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String name = "";

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ref.watch(getContactsProvider).when(
                      data: (contactList) => ListView.separated(
                        itemCount: contactList.length,
                        itemBuilder: (context, index) {
                          var contact = contactList[index];
                          if (name.isEmpty) {
                            return ListTile(
                              onTap: () => selectContact(
                                context: context,
                                ref: ref,
                                selectedContact: contact,
                              ),
                              title: Text(contact.displayName),
                              leading: const CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                ),
                              ),
                            );
                          } else if (contact.displayName
                              .toString()
                              .toLowerCase()
                              .contains(name.toLowerCase())) {
                            return ListTile(
                              onTap: () => selectContact(
                                context: context,
                                ref: ref,
                                selectedContact: contact,
                              ),
                              title: Text(contact.displayName),
                              leading: const CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                      ),
                      error: (error, stackTrace) {
                        return ErrorHandel(error: error.toString());
                      },
                      loading: () => const LoadingHandel(),
                    ),

                // FutureBuilder<List<Contact>>(
                //   future: ref.watch(getContactsProvider);,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     } else {
                //       return ListView.separated(
                //         itemCount: snapshot.data!.docs.length,
                //         itemBuilder: (context, index) {
                //           var userData = snapshot.data!.docs[index].data()
                //               as Map<String, dynamic>;
                //           UserModel user = UserModel.fromMap(userData);
                //           if (name.isEmpty) {
                //             return ListTile(
                //               onTap: () => Navigator.pushReplacementNamed(
                //                   context, MobileChatScreen.routeName,
                //                   arguments: {
                //                     "name": user.name,
                //                     "uid": user.uid,
                //                     "profilePicture": user.profilePicture,
                //                     "isGroupChat": false,
                //                   }),
                //               title: Text(user.name),
                //               leading: CircleAvatar(
                //                 radius: 30,
                //                 backgroundImage: NetworkImage(
                //                   user.profilePicture,
                //                 ),
                //               ),
                //             );
                //           } else if (user.name
                //               .toString()
                //               .toLowerCase()
                //               .startsWith(name.toLowerCase())) {
                //             return ListTile(
                //               // onTap: () => selectContact(
                //               //   context: context,
                //               //   ref: ref,
                //               //   selectedContact: snapshot.data![index],
                //               // ),
                //               title: Text(user.name),
                //               leading: CircleAvatar(
                //                 radius: 30,
                //                 backgroundImage: NetworkImage(
                //                   user.profilePicture,
                //                 ),
                //               ),
                //             );
                //           } else {
                //             return const SizedBox.shrink();
                //           }
                //         },
                //         separatorBuilder: (context, index) =>
                //             const Divider(color: Colors.grey),
                //       );
                //     }
                //   },
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
