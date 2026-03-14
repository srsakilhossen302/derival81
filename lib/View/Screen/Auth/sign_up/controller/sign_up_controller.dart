import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';
import '../../otp/view/otp_screen.dart';

class SignUpController extends GetxController {
  // Text Editing Controllers for all input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observable variable for Terms and Conditions checkbox
  var isChecked = false.obs;

  // Observable variable for loading state during API call
  var isLoading = false.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Method to toggle the checkbox
  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  // Method to handle Sign Up API logic
  Future<void> signUpUser() async {
    // Basic validation check
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      CustomToast.showWarning("Required", "Please fill in all the fields");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      CustomToast.showError("Error", "Passwords do not match");
      return;
    }

    if (!isChecked.value) {
      CustomToast.showWarning("Hold On! ✋", "Please agree to the Terms and Conditions before proceeding.");
      return;
    }

    try {
      isLoading.value = true;
      
      // Simulating API network delay
      await Future.delayed(const Duration(seconds: 2));

      // Assuming successful registration
      CustomToast.showSuccess("Success", "Account created successfully!");

      // Clear fields
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Navigate to OTP screen
      Get.to(() => OtpScreen(), arguments: 'signup');

    } catch (e) {
      CustomToast.showError("Oh Snap!", "Something went wrong while signing up. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
