import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../service/api_url.dart';
import '../../../../../Utils/ToastMessage/custom_toast.dart';
import '../../payment_method/view/payment_method_screen.dart';

class CompleteProfileController extends GetxController {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  var isLoading = false.obs;
  var isImageUploading = false.obs;
  var imagePath = "".obs;
  final ImagePicker _picker = ImagePicker();

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

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
        await _uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      print("Image Picker Error: $e");
      CustomToast.showError("Error", "Failed: ${e.toString()}");
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      isImageUploading.value = true;
      CustomToast.showSuccess("Uploading", "Please wait while your image is uploading...");
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.uploadProfileImageUrl));
      
      if (token != null) {
        request.headers['Authorization'] = token;
      }
      
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomToast.showSuccess("Success", "Profile image uploaded successfully");
      } else {
        var data = jsonDecode(response.body);
        CustomToast.showError("Error", data['message'] ?? "Failed to upload image");
      }
    } catch (e) {
      CustomToast.showError("Error", "Something went wrong while uploading image");
    } finally {
      isImageUploading.value = false;
    }
  }

  Future<void> submitProfile() async {
    if (dobController.text.isEmpty ||
        occupationController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        zipController.text.isEmpty) {
      CustomToast.showWarning("Required", "Please fill all the fields");
      return;
    }

    try {
      isLoading.value = true;
      // TODO: API Call to POST profile data
      await Future.delayed(const Duration(seconds: 2));

      CustomToast.showSuccess("Success", "Profile completed successfully!");

      // Navigate to Payment Method Screen
      Get.to(() => PaymentMethodScreen());
    } catch (e) {
      CustomToast.showError("Error", "Failed to update profile");
    } finally {
      isLoading.value = false;
    }
  }

  void skipForNow() {
    // Navigate straight to Payment Method Screen
    Get.to(() => PaymentMethodScreen());
  }
}
