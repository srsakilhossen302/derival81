import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../complete_profile/view/complete_profile_screen.dart';
import '../../set_password/view/set_password_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../service/api_url.dart';
import '../../login/view/login_screen.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  var isLoading = false.obs;

  Future<void> confirmOtp() async {
    // Implement confirm OTP logic
    if (otpController.text.length == 4) {
      var args = Get.arguments;
      
      if (args != null && args is Map && args['type'] == 'signup') {
        String email = args['email'] ?? '';
        if (email.isEmpty) {
          CustomToast.showError("Error", "Email not found. Please try again.");
          return;
        }

        try {
          isLoading.value = true;
          var response = await http.post(
            Uri.parse(ApiUrl.verifyEmailUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              "email": email,
              "code": otpController.text,
            }),
          );

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['success'] == true) {
              CustomToast.showSuccess(
                "Success",
                data['message'] ?? "Email verified successfully.",
              );
              Get.offAll(() => LoginScreen());
            } else {
              CustomToast.showError(
                "Error",
                data['message'] ?? "Verification failed.",
              );
            }
          } else {
            var data = jsonDecode(response.body);
            CustomToast.showError(
              "Error",
              data['message'] ?? "Verification failed. Please try again.",
            );
          }
        } catch (e) {
          CustomToast.showError("Oh Snap!", "Something went wrong.");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.to(() => SetPasswordScreen());
      }
    } else {
      Get.snackbar("Error", "Please enter a valid 4-digit OTP");
    }
  }
  Future<void> resendOtp() async {
    var args = Get.arguments;
    if (args != null && args is Map && args['type'] == 'signup') {
      String email = args['email'] ?? '';
      if (email.isEmpty) {
        CustomToast.showError("Error", "Email not found.");
        return;
      }

      try {
        var response = await http.post(
          Uri.parse(ApiUrl.resendVerificationCodeUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"email": email}),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = jsonDecode(response.body);
          CustomToast.showSuccess(
            "Success",
            data['message'] ?? "OTP sent successfully.",
          );
        } else {
          var data = jsonDecode(response.body);
          CustomToast.showError(
            "Error",
            data['message'] ?? "Failed to resend OTP.",
          );
        }
      } catch (e) {
        CustomToast.showError("Oh Snap!", "Something went wrong.");
      }
    } else {
      // In case we are coming from a different flow where email might not be present
      // you could handle it or leave a message.
      CustomToast.showError("Error", "Cannot resend OTP at this stage.");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
