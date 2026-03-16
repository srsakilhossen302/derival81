class GroupModel {
  final String id;
  final String name;
  final String description;
  final String status; // active, pending, completed
  final int membersCount;
  final int totalMembers;
  final double amount;
  final int position;
  final String nextDate;
  final double progress;

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
  });
}
