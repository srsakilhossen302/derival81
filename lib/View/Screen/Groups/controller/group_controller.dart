import 'package:get/get.dart';
import '../model/group_model.dart';

class GroupController extends GetxController {
  var groups = <GroupModel>[].obs; // Empty list for now as per screenshot
  var selectedFilter = "All".obs;
  
  final List<String> filters = ["All", "Active", "Pending", "Completed"];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
