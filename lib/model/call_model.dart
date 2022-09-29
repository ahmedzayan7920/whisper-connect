class CallModel {
  final String callerId;
  final String callerName;
  final String callerPicture;
  final String receiverId;
  final String receiverName;
  final String receiverPicture;
  final String callId;
  final bool hasDialled;

  CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerPicture,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPicture,
    required this.callId,
    required this.hasDialled,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callerPicture': callerPicture,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPicture': receiverPicture,
      'callId': callId,
      'hasDialled': hasDialled,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPicture: map['callerPicture'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPicture: map['receiverPicture'] ?? '',
      callId: map['callId'] ?? '',
      hasDialled: map['hasDialled'] ?? false,
    );
  }
}
