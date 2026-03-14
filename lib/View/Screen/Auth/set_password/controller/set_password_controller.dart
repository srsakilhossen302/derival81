import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  var isLoading = false.obs;

  void savePassword() {
    if (newPasswordController.text == confirmPasswordController.text && newPasswordController.text.isNotEmpty) {
      Get.snackbar("Success", "Password updated successfully");
      Get.offAllNamed('/login');
    } else {
      Get.snackbar("Error", "Passwords do not match or are empty");
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
