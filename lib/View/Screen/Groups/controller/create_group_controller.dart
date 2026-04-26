import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../service/api_url.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';
import 'group_controller.dart';
import '../model/group_model.dart';
import '../view/group_details_screen.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();

  final amountController = TextEditingController(text: "500");
  final frequencyController = TextEditingController(text: "monthly");
  final groupSizeController = TextEditingController(text: "10");
  
  final frequencies = ['weekly', 'monthly', 'yearly'];
  var selectedFrequency = 'monthly'.obs;

  var currentStep = 1.obs;
  var isLoading = false.obs;
  var isImageUploading = false.obs;
  var imagePath = "".obs;
  var groupImageUrl = "".obs;
  final ImagePicker _picker = ImagePicker();

  void goToNextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void goBack() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
        await _uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      CustomToast.showError("Error", "Failed to pick image");
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      isImageUploading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.uploadProfileImageUrl));
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['profileImage'] != null) {
          groupImageUrl.value = data['data']['profileImage'];
        } else if (data['url'] != null) {
          groupImageUrl.value = data['url'];
        }
        CustomToast.showSuccess("Success", "Image uploaded successfully");
      } else {
        CustomToast.showError("Error", "Failed to upload image");
      }
    } catch (e) {
      CustomToast.showError("Error", "Something went wrong while uploading image");
    } finally {
      isImageUploading.value = false;
    }
  }

  Future<void> createGroup() async {
    if (groupNameController.text.isEmpty) {
      CustomToast.showWarning("Required", "Please enter group name");
      return;
    }

    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null) {
        CustomToast.showError("Error", "Authentication token not found");
        return;
      }

      var requestBody = {
        "name": groupNameController.text,
        "description": descriptionController.text,
        "contributionAmount": int.tryParse(amountController.text) ?? 500,
        "contributionFrequency": frequencyController.text.toLowerCase(),
        "totalMembers": int.tryParse(groupSizeController.text) ?? 10,
        "startDate": DateTime.now().toIso8601String().split('T')[0],
        "image": groupImageUrl.value,
      };

      var response = await http.post(
        Uri.parse(ApiUrl.groupsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        var groupData = data['data'];
        
        CustomToast.showSuccess("Success", "Group created successfully!");
        
        final GroupController groupController = Get.find<GroupController>();
        final newGroup = GroupModel(
          id: groupData['_id'] ?? groupData['id'] ?? DateTime.now().toString(),
          name: groupData['name'] ?? groupNameController.text,
          description: groupData['description'] ?? descriptionController.text,
          status: groupData['status'] ?? 'Active',
          membersCount: groupData['membersCount'] ?? 1,
          totalMembers: groupData['totalMembers'] ?? (int.tryParse(groupSizeController.text) ?? 10),
          amount: (groupData['contributionAmount'] ?? (double.tryParse(amountController.text) ?? 500.0)).toDouble(),
          position: 1,
          nextDate: groupData['startDate'] ?? "",
          progress: 0.1,
        );
        groupController.groups.add(newGroup);
        
        Get.off(() => GroupDetailsScreen(group: newGroup));
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError("Error", data['message'] ?? "Failed to create group");
      }
    } catch (e) {
      print("Create Group Exception: $e");
      CustomToast.showError("Error", "Failed to create group");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    groupNameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    frequencyController.dispose();
    groupSizeController.dispose();
    super.onClose();
  }
}
