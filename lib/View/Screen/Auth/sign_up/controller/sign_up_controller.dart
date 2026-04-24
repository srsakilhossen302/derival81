import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';
import '../../otp/view/otp_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../service/api_url.dart';

class SignUpController extends GetxController {
  // Text Editing Controllers for all input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String fullPhoneNumber = '';

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
        fullPhoneNumber.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      CustomToast.showWarning("Required", "Please fill in all the fields");
      return;
    }

    // Password validation: 8+ characters, letters, numbers, and special characters
    String password = passwordController.text;
    if (password.length < 8) {
      CustomToast.showWarning(
        "Too Short",
        "Password must be at least 8 characters long",
      );
      return;
    }

    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    if (!hasLetter || !hasNumber || !hasSpecialChar) {
      CustomToast.showWarning(
        "Weak Password",
        "Password must contain a mix of letters, numbers, and special characters",
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      CustomToast.showError("", "Passwords do not match");
      return;
    }

    if (!isChecked.value) {
      CustomToast.showWarning(
        "Hold On! ✋",
        "Please agree to the Terms and Conditions before proceeding.",
      );
      return;
    }

    try {
      isLoading.value = true;

      var response = await http.post(
        Uri.parse(ApiUrl.registerUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "fullName": fullNameController.text,
          "email": emailController.text,
          "phone": fullPhoneNumber,
          "password": passwordController.text,
          "agreeToTerms": isChecked.value,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        CustomToast.showSuccess("Success", "Account created successfully!");

        String userEmail = emailController.text;

        // Clear fields
        fullNameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        fullPhoneNumber = '';

        // Navigate to OTP screen
        Get.to(() => OtpScreen(), arguments: {
          'type': 'signup',
          'email': userEmail,
        });
      } else {
        var data = jsonDecode(response.body);
        print("API Error Response: ${response.body}");
        
        String errorMessage = data['message'] ?? "Registration failed. Please try again.";
        
        // Extract detailed validation message if it's a Zod Error
        if (data['errorSources'] != null && data['errorSources'] is List && data['errorSources'].isNotEmpty) {
          errorMessage = data['errorSources'][0]['message'] ?? errorMessage;
        } else if (data['errors'] != null && data['errors'] is List && data['errors'].isNotEmpty) {
          var firstError = data['errors'][0];
          if (firstError is Map && firstError['message'] != null) {
            errorMessage = firstError['message'];
          } else if (firstError is String) {
            errorMessage = firstError;
          }
        }

        CustomToast.showError(
          "Registration Failed",
          errorMessage,
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Oh Snap!",
        "Something went wrong while signing up. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
