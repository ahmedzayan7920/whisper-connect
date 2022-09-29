import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:chat_app/common/enums/message_type.dart';
import 'package:chat_app/common/providers/message_replay_provider.dart';
import 'package:chat_app/common/repository/common_firebase_strorage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/model/chat_contact_model.dart';
import 'package:chat_app/model/group_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<MessageModel>> getChatMessages(String receiverUserId) {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .doc(receiverUserId)
        .collection("messages")
        .orderBy("sentTime")
        .snapshots()
        .asyncMap((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        MessageModel message = MessageModel.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return firestore
        .collection("groups")
        .doc(groupId)
        .collection("chats")
        .orderBy("sentTime")
        .snapshots()
        .asyncMap((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        MessageModel message = MessageModel.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("chats")
        .orderBy("sentTime")
        .snapshots()
        .asyncMap((event) {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        ChatContactModel chatContact =
            ChatContactModel.fromMap(document.data());
        contacts.add(chatContact);
      }
      return contacts;
    });
  }

  Stream<List<GroupModel>> getChatGroups() {
    return firestore.collection("groups").snapshots().asyncMap((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        GroupModel group = GroupModel.fromMap(document.data());
        if (group.groupMembers.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  void _saveDataToContactsSubCollection({
    required UserModel senderUser,
    required UserModel? receiverUser,
    required String receiverId,
    required String lastMessage,
    required DateTime sentTime,
    required bool isGroupChat,
  }) async {
    if (isGroupChat) {
      await firestore.collection("groups").doc(receiverId).update({
        "groupLastMessage": lastMessage,
        "sentTime": DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      ChatContactModel receiverChatContact = ChatContactModel(
        uid: senderUser.uid,
        name: senderUser.name,
        profilePicture: senderUser.profilePicture,
        lastMessage: lastMessage,
        sentTime: sentTime,
      );

      await firestore
          .collection("users")
          .doc(receiverUser!.uid)
          .collection("chats")
          .doc(senderUser.uid)
          .set(receiverChatContact.toMap());

      ChatContactModel senderChatContact = ChatContactModel(
        uid: receiverUser.uid,
        name: receiverUser.name,
        profilePicture: receiverUser.profilePicture,
        lastMessage: lastMessage,
        sentTime: sentTime,
      );

      await firestore
          .collection("users")
          .doc(senderUser.uid)
          .collection("chats")
          .doc(receiverUser.uid)
          .set(senderChatContact.toMap());
    }
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String senderUserId,
    required String senderUserName,
    required String text,
    required String messageId,
    required String senderUsername,
    required String? receiverUsername,
    required DateTime sentTime,
    required MessageType messageType,
    required MessageReplayModel? messageReplay,
    required bool isGroupChat,
  }) async {
    MessageModel message = MessageModel(
      senderId: senderUserId,
      senderName: senderUserName,
      receiverId: receiverUserId,
      text: text,
      id: messageId,
      type: messageType,
      sentTime: sentTime,
      isSeen: false,
      repliedMessage: messageReplay == null ? "" : messageReplay.message,
      repliedTo: messageReplay == null ? "" : messageReplay.senderName,
      repliedMessageType:
          messageReplay == null ? MessageType.text : messageReplay.messageType,
    );
    if (isGroupChat) {
      await firestore
          .collection("groups")
          .doc(receiverUserId)
          .collection("chats")
          .doc(messageId)
          .set(message.toMap());
    } else {
      await firestore
          .collection("users")
          .doc(senderUserId)
          .collection("chats")
          .doc(receiverUserId)
          .collection("messages")
          .doc(messageId)
          .set(message.toMap());

      await firestore
          .collection("users")
          .doc(receiverUserId)
          .collection("chats")
          .doc(senderUserId)
          .collection("messages")
          .doc(messageId)
          .set(message.toMap());
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderUser,
    required MessageReplayModel? messageReplay,
    required bool isGroupChat,
  }) async {
    try {
      DateTime sentTime = DateTime.now();
      String messageId = const Uuid().v1();
      UserModel? receiverUser;

      if (!isGroupChat) {
        var receiverData =
            await firestore.collection("users").doc(receiverId).get();
        receiverUser = UserModel.fromMap(receiverData.data()!);
      }
      _saveDataToContactsSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        receiverId: receiverId,
        lastMessage: text,
        sentTime: sentTime,
        isGroupChat: isGroupChat,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverId,
        senderUserId: senderUser.uid,
        senderUserName: senderUser.name,
        text: text,
        messageId: messageId,
        senderUsername: senderUser.name,
        receiverUsername: receiverUser?.name,
        sentTime: sentTime,
        messageType: MessageType.text,
        messageReplay: messageReplay,
        isGroupChat: isGroupChat,
      );
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverId,
    required UserModel senderUser,
    required ProviderRef ref,
    required MessageType messageType,
    required MessageReplayModel? messageReplay,
    required bool isGroupChat,
  }) async {
    try {
      bool isOpen = false;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          isOpen = true;
          return AlertDialog(
            title: const Text("Sending Message..."),
            content: Row(
              children: const [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(width: 15),
                Text("Please wait")
              ],
            ),
          );
        },
      ).then((value) {
        isOpen = false;
      });
      DateTime sentTime = DateTime.now();
      String messageId = const Uuid().v1();
      UserModel? receiverUser;
      String downloadUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            ref:
                "chat/${messageType.type}/${senderUser.uid}/$receiverId/$messageId",
            file: file,
          );

      String contactMessage = "";
      switch (messageType) {
        case MessageType.text:
          contactMessage = "Error Text";
          break;
        case MessageType.image:
          contactMessage = "🖼 Image";
          break;
        case MessageType.audio:
          contactMessage = "🎵 Audio";
          break;
        case MessageType.video:
          contactMessage = "📽 Video";
          break;
        case MessageType.gif:
          contactMessage = "GIF";
          break;
      }

      if (!isGroupChat) {
        var receiverData =
            await firestore.collection("users").doc(receiverId).get();
        receiverUser = UserModel.fromMap(receiverData.data()!);
      }
      _saveDataToContactsSubCollection(
        senderUser: senderUser,
        receiverUser: receiverUser,
        receiverId: receiverId,
        lastMessage: contactMessage,
        sentTime: sentTime,
        isGroupChat: isGroupChat,
      );

      _saveMessageToMessageSubCollection(
        receiverUserId: receiverId,
        senderUserId: senderUser.uid,
        senderUserName: senderUser.name,
        text: downloadUrl,
        messageId: messageId,
        senderUsername: senderUser.name,
        receiverUsername: receiverUser?.name,
        sentTime: sentTime,
        messageType: messageType,
        messageReplay: messageReplay,
        isGroupChat: isGroupChat,
      );
      if (isOpen) {
        Navigator.pop(context);
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

// void sendGifMessage({
//   required BuildContext context,
//   required String gifUrl,
//   required String receiverUserId,
//   required UserModel senderUser,
//   required bool isGroupChat,
// }) async {
//   try {
//     DateTime sentTime = DateTime.now();
//     String messageId = const Uuid().v1();
//     var receiverData =
//     await firestore.collection("users").doc(receiverUserId).get();
//     UserModel receiverUser = UserModel.fromMap(receiverData.data()!);
//
//     _saveDataToContactsSubCollection(
//       senderUser: senderUser,
//       receiverUser: receiverUser,
//       lastMessage: "GIF",
//       sentTime: sentTime,
//     );
//
//     _saveMessageToMessageSubCollection(
//       receiverUserId: receiverUser.uid,
//       senderUserId: senderUser.uid,
//       text: gifUrl,
//       messageId: messageId,
//       senderUsername: senderUser.name,
//       receiverUsername: receiverUser.name,
//       sentTime: sentTime,
//       messageType: MessageType.gif,
//     );
//   } catch (error) {
//     showSnackBar(context: context, content: error.toString());
//   }
// }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("chats")
          .doc(receiverUserId)
          .collection("messages")
          .doc(messageId)
          .update({"isSeen": true});

      await firestore
          .collection("users")
          .doc(receiverUserId)
          .collection("chats")
          .doc(auth.currentUser!.uid)
          .collection("messages")
          .doc(messageId)
          .update({"isSeen": true});
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
