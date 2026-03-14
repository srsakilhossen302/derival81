import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../complete_profile/view/complete_profile_screen.dart';
import '../../set_password/view/set_password_screen.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var isLoading = false.obs;

  void confirmOtp() {
    // Implement confirm OTP logic
    if (otpController.text.length == 4) {
      if (Get.arguments == 'signup') {
        Get.offAll(() => CompleteProfileScreen());
      } else {
        Get.to(() => SetPasswordScreen());
      }
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
