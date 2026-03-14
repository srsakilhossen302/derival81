import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;

  void sendResetLink() {
    // Implement send reset link logic
    if (emailController.text.isNotEmpty) {
      Get.snackbar("Success", "Reset link sent to ${emailController.text}");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
