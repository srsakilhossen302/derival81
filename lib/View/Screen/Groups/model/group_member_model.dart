class GroupMemberModel {
  final String id;
  final String fullName;
  final String profileImage;
  final int position;
  final String status;
  final int joinMonth;
  final String paymentStatus;
  final double totalPaidAmount;

  GroupMemberModel({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.position,
    required this.status,
    required this.joinMonth,
    this.paymentStatus = 'pending',
    this.totalPaidAmount = 0.0,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    final user = json['userId'] ?? {};
    return GroupMemberModel(
      id: user['_id'] ?? '',
      fullName: user['fullName'] ?? 'Unknown',
      profileImage: user['profileImage'] ?? '',
      position: json['position'] ?? 0,
      status: json['status'] ?? 'active',
      joinMonth: json['joinMonth'] ?? 1,
      paymentStatus: json['paymentStatus'] ?? 'pending',
      totalPaidAmount: (json['totalPaidAmount'] ?? 0).toDouble(),
    );
  }
}
