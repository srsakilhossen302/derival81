import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Home/view/home_screen.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    // Implement login logic
    Get.offAll(() => HomeScreen());
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
