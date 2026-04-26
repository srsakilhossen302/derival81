class GroupModel {
  final String id;
  final String name;
  final String description;
  final String status;
  final int membersCount;
  final int totalMembers;
  final double amount;
  final int position;
  final String nextDate;
  final double progress;
  final String? adminName;
  final String? adminImage;
  final String? contributionFrequency;

  GroupModel({
    required this.id,
    required this.name,
    this.description = "Monthly savings for family members",
    required this.status,
    required this.membersCount,
    this.totalMembers = 10,
    required this.amount,
    this.position = 8,
    this.nextDate = "4/1/2026",
    this.progress = 0.8,
    this.adminName,
    this.adminImage,
    this.contributionFrequency,
    this.inviteCode,
  });

  final String? inviteCode;

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? 'Monthly savings for family members',
      status: json['status'] ?? 'active',
      membersCount: json['currentMembers'] ?? 0,
      totalMembers: json['totalMembers'] ?? 10,
      amount: (json['contributionAmount'] ?? 0).toDouble(),
      position: 1, // Default value as it's not in the invite API response
      nextDate: json['startDate'] ?? 'N/A',
      progress: (json['currentMembers'] ?? 0) / (json['totalMembers'] ?? 1),
      adminName: json['createdBy'] != null
          ? json['createdBy']['fullName']
          : 'Unknown',
      adminImage: json['createdBy'] != null
          ? json['createdBy']['profileImage']
          : null,
      contributionFrequency: json['contributionFrequency'] ?? 'monthly',
      inviteCode: json['inviteCode'],
    );
  }
}
