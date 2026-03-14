import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompleteProfileController extends GetxController {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  var isLoading = false.obs;
  var imagePath = "".obs;

  @override
  void onClose() {
    dobController.dispose();
    occupationController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.onClose();
  }

  void pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A227F),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dobController.text =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  void pickImage() {
    // You can use image_picker here later. 
    // Right now, this acts as a placeholder function.
  }

  Future<void> submitProfile() async {
    if (dobController.text.isEmpty ||
        occupationController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        zipController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "Please fill all the fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      // TODO: API Call to POST profile data
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        "Success",
        "Profile completed successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF155DFC),
        colorText: Colors.white,
      );

      // Navigate to the next screen here
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void skipForNow() {
    // Navigate straight to dashboard or next screen
  }
}
