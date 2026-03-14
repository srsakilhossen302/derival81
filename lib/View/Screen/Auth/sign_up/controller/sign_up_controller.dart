import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      Get.snackbar(
        "Error",
        "Please fill in all the fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!isChecked.value) {
      Get.snackbar(
        "Wait",
        "Please agree to the Terms and Conditions",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      
      // TODO: Call your actual POST API here
      // For example using http or specialized API service client
      // final response = await ApiClient.postData(ApiUrl.signUp, data);

      // Simulating API network delay
      await Future.delayed(const Duration(seconds: 2));

      // Assuming successful registration
      Get.snackbar(
        "Success",
        "Account created successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF155DFC),
        colorText: Colors.white,
      );

      // Need to clear fields or navigate to next screen here
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong while signing up.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
