class GroupModel {
  final String senderId;
  final String groupName;
  final String groupId;
  final String groupLastMessage;
  final String groupPicture;
  final List<String> groupMembers;
  final DateTime sentTime;

  GroupModel({
    required this.senderId,
    required this.groupName,
    required this.groupId,
    required this.groupLastMessage,
    required this.groupPicture,
    required this.groupMembers,
    required this.sentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'groupName': groupName,
      'groupId': groupId,
      'groupLastMessage': groupLastMessage,
      'groupPicture': groupPicture,
      'groupMembers': groupMembers,
      'sentTime': sentTime.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      senderId: map['senderId'] ?? '',
      groupName: map['groupName'] ?? '',
      groupId: map['groupId'] ?? '',
      groupLastMessage: map['groupLastMessage'] ?? '',
      groupPicture: map['groupPicture'] ?? '',
      groupMembers: List<String>.from(map['groupMembers']),
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime']),
    );
  }
}
