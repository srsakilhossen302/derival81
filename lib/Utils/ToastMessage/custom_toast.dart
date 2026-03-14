import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomToast {
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF155DFC).withOpacity(0.95),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderWidth: 1,
      borderColor: Colors.white.withOpacity(0.2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent.withOpacity(0.95),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 28),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderWidth: 1,
      borderColor: Colors.white.withOpacity(0.2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static void showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orangeAccent.withOpacity(0.95),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderWidth: 1,
      borderColor: Colors.white.withOpacity(0.2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
