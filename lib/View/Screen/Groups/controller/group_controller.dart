import 'dart:convert';
import 'package:derival81/View/Screen/Groups/view/active_group_details_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/group_member_model.dart';
import '../model/group_model.dart';
import '../../../../../service/api_url.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';

class GroupController extends GetxController {
  var groups = <GroupModel>[].obs;

  var selectedFilter = "All".obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyGroups();
  }

  Future<void> fetchMyGroups() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        return;
      }

      var response = await http.get(
        Uri.parse(ApiUrl.myGroupsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          var groupsList = data['data'] as List;
          groups.value = groupsList.map((g) => GroupModel.fromJson(g)).toList();
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError(
          "Error",
          data['message'] ?? "Failed to fetch groups",
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Error",
        "Something went wrong while fetching groups",
      );
    } finally {
      isLoading.value = false;
    }
  }

  var isLoading = false.obs;
  var activeGroupDetails = Rxn<GroupModel>();

  Future<void> fetchGroupDetails(String id) async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        return;
      }

      var response = await http.get(
        Uri.parse('${ApiUrl.groupsUrl}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          activeGroupDetails.value = GroupModel.fromJson(data['data']);
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError(
          "Error",
          data['message'] ?? "Failed to fetch group details",
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Error",
        "Something went wrong while fetching group details",
      );
    } finally {
      isLoading.value = false;
    }
  }

  var groupMembers = <GroupMemberModel>[].obs;
  var isMembersLoading = false.obs;

  Future<void> fetchGroupMembers(String groupId) async {
    try {
      isMembersLoading.value = true;
      groupMembers.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        return;
      }

      var response = await http.get(
        Uri.parse(ApiUrl.groupMembersUrl(groupId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          var membersList = data['data'] as List;
          groupMembers.value = membersList
              .map((m) => GroupMemberModel.fromJson(m))
              .toList();
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError(
          "Error",
          data['message'] ?? "Failed to fetch members",
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Error",
        "Something went wrong while fetching members",
      );
    } finally {
      isMembersLoading.value = false;
    }
  }

  var searchedGroup = Rxn<GroupModel>();

  final List<String> filters = [
    "All",
    "Active",
    "Upcoming",
    "Pending",
    "Completed",
  ];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<GroupModel> get filteredGroups {
    if (selectedFilter.value == 'All') return groups;
    return groups
        .where(
          (g) => g.status.toLowerCase() == selectedFilter.value.toLowerCase(),
        )
        .toList();
  }

  Future<void> fetchGroupByInviteCode(String inviteCode) async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        CustomToast.showError("Error", "Authentication token not found");
        return;
      }

      var response = await http.get(
        Uri.parse(ApiUrl.getInviteGroupUrl(inviteCode)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          searchedGroup.value = GroupModel.fromJson(data['data']);
        } else {
          CustomToast.showError(
            "Error",
            data['message'] ?? "Failed to find group",
          );
          searchedGroup.value = null;
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError(
          "Error",
          data['message'] ?? "Failed to fetch group details",
        );
        searchedGroup.value = null;
      }
    } catch (e) {
      CustomToast.showError(
        "Error",
        "Something went wrong while fetching group",
      );
      searchedGroup.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinGroup(String inviteCode) async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        CustomToast.showError("Error", "Authentication token not found");
        return;
      }

      var response = await http.post(
        Uri.parse(ApiUrl.joinGroupUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"inviteCode": inviteCode}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['success'] == true) {
          CustomToast.showSuccess(
            "Success",
            data['message'] ?? "Joined group successfully",
          );
          // Optionally refresh groups list or navigate
          if (searchedGroup.value != null) {
            Get.to(() => ActiveGroupDetailsScreen(group: searchedGroup.value!));
          }
        } else {
          CustomToast.showError(
            "Error",
            data['message'] ?? "Failed to join group",
          );
        }
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError(
          "Error",
          data['message'] ?? "Failed to join group",
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Error",
        "Something went wrong while joining group",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGroup(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        CustomToast.showError("Error", "Authentication token not found");
        return;
      }

      var response = await http.delete(
        Uri.parse('${ApiUrl.groupsUrl}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        groups.removeWhere((g) => g.id == id);
        CustomToast.showSuccess("Success", "Group deleted successfully");
        Get.back(); // Close dialog
        Get.back(); // Go back to GroupScreen
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError(
          "Error",
          data['message'] ?? "Failed to delete group",
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Error",
        "Something went wrong while deleting group",
      );
    }
  }
}
