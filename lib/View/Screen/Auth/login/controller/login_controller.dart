import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Home/view/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../service/api_url.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../complete_profile/view/complete_profile_screen.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CustomToast.showWarning("Required", "Please fill in all the fields");
      return;
    }

    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse(ApiUrl.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        
        // Save Tokens and Check Profile
        var responseData = data['data'];
        if (responseData != null) {
          String? accessToken = responseData['accessToken'];
          String? refreshToken = responseData['refreshToken'];
          bool? isUpdatedProfile = responseData['user']?['isUpdatedProfile'];
          
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (accessToken != null) {
            await prefs.setString('accessToken', accessToken);
          }
          if (refreshToken != null) {
            await prefs.setString('refreshToken', refreshToken);
          }
          
          CustomToast.showSuccess(
            "Welcome Back!",
            data['message'] ?? "Logged in successfully.",
          );
          
          if (isUpdatedProfile == false) {
            Get.offAll(() => CompleteProfileScreen());
          } else {
            Get.offAll(() => HomeScreen());
          }
        } else {
          CustomToast.showSuccess(
            "Welcome Back!",
            data['message'] ?? "Logged in successfully.",
          );
          Get.offAll(() => HomeScreen());
        }
      } else {
        var data = jsonDecode(response.body);
        print("API Error Response: ${response.body}");

        String errorMessage = data['message'] ?? "Login failed. Please try again.";

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
          "Login Failed",
          errorMessage,
        );
      }
    } catch (e) {
      CustomToast.showError(
        "Oh Snap!",
        "Something went wrong while logging in. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithGoogle() {
    // Implement google login
  }

  void loginWithFacebook() {
    // Implement facebook login
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
