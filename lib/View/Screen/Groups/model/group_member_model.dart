class GroupMemberModel {
  final String id;
  final String fullName;
  final String profileImage;
  final int position;
  final String status;
  final int joinMonth;

  GroupMemberModel({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.position,
    required this.status,
    required this.joinMonth,
  });

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) {
    return GroupMemberModel(
      id: json['userId'] != null ? json['userId']['_id'] ?? '' : '',
      fullName: json['userId'] != null ? json['userId']['fullName'] ?? 'Unknown' : 'Unknown',
      profileImage: json['userId'] != null ? json['userId']['profileImage'] ?? '' : '',
      position: json['position'] ?? 0,
      status: json['status'] ?? 'active',
      joinMonth: json['joinMonth'] ?? 1,
    );
  }
}
