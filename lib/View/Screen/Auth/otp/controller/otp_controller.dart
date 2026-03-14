import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var isLoading = false.obs;

  void confirmOtp() {
    // Implement confirm OTP logic
    if (otpController.text.length == 4) {
      Get.snackbar("Success", "OTP Verified");
      // Navigate to Reset Password screen (or similar)
      // Get.toNamed('/new-password');
    } else {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
