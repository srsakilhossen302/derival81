import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../otp/view/otp_screen.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  var isLoading = false.obs;

  void sendResetLink() {
    // Implement send reset link logic
    if (emailController.text.isNotEmpty) {
      Get.to(() => OtpScreen());
    } else {
      Get.snackbar("Error", "Please enter your email");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
