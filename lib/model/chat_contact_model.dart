class ChatContactModel {
  final String uid;
  final String name;
  final String profilePicture;
  final String lastMessage;
  final DateTime sentTime;

  ChatContactModel({
    required this.uid,
    required this.name,
    required this.profilePicture,
    required this.lastMessage,
    required this.sentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePicture,
      'contactId': uid,
      'sentTime': sentTime.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContactModel.fromMap(Map<String, dynamic> map) {
    return ChatContactModel(
      name: map['name'] ?? '',
      profilePicture: map['profilePic'] ?? '',
      uid: map['contactId'] ?? '',
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
