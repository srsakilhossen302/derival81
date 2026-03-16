import 'package:get/get.dart';
import '../model/group_model.dart';

class GroupController extends GetxController {
  var groups = <GroupModel>[
    GroupModel(
      id: "1",
      name: "Labib Circle",
      description: "Monthly savings for family members",
      status: "Active",
      membersCount: 9,
      totalMembers: 10,
      amount: 100.0,
      position: 8,
      nextDate: "4/1/2026",
      progress: 0.9,
    ),
    GroupModel(
      id: "2",
      name: "Family Savings",
      description: "Local community fund group",
      status: "Active",
      membersCount: 4,
      totalMembers: 6,
      amount: 250.0,
      position: 2,
      nextDate: "4/15/2026",
      progress: 0.3,
    ),
    GroupModel(
      id: "3",
      name: "Friends Fund",
      description: "Monthly contribution for business",
      status: "Active",
      membersCount: 12,
      totalMembers: 15,
      amount: 500.0,
      position: 10,
      nextDate: "5/1/2026",
      progress: 0.6,
    ),
  ].obs;
  
  var selectedFilter = "All".obs;
  
  final List<String> filters = ["All", "Active", "Pending", "Completed"];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
