class ChatMessageModel {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String senderProfileImage;
  final String message;
  final String messageType;
  final String createdAt;

  ChatMessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    required this.senderProfileImage,
    required this.message,
    required this.messageType,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'] ?? '',
      groupId: json['groupId'] ?? '',
      senderId: json['senderId'] != null ? json['senderId']['_id'] ?? '' : '',
      senderName: json['senderId'] != null ? json['senderId']['fullName'] ?? 'Unknown' : 'Unknown',
      senderProfileImage: json['senderId'] != null ? json['senderId']['profileImage'] ?? '' : '',
      message: json['message'] ?? '',
      messageType: json['messageType'] ?? 'text',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
