class StatusModel {
  final String uid;
  final String phoneNumber;
  final String username;
  final List<String> photoUrls;
  final DateTime createdAt;
  final String profilePicture;
  final String statusId;
  final List<String> whoCanSee;

  StatusModel({
    required this.uid,
    required this.phoneNumber,
    required this.username,
    required this.photoUrls,
    required this.createdAt,
    required this.profilePicture,
    required this.statusId,
    required this.whoCanSee,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrls': photoUrls,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePicture': profilePicture,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrls: List<String>.from(map['photoUrls']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      profilePicture: map['profilePicture'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
