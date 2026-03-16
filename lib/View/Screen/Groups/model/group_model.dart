class GroupModel {
  final String id;
  final String name;
  final String status; // active, pending, completed
  final int membersCount;
  final double totalAmount;

  GroupModel({
    required this.id,
    required this.name,
    required this.status,
    required this.membersCount,
    required this.totalAmount,
  });
}
