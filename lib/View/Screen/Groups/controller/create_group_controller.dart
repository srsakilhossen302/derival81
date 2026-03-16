import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  
  final amountController = TextEditingController(text: "500");
  final frequencyController = TextEditingController(text: "Monthly");
  final groupSizeController = TextEditingController(text: "10");
  
  var currentStep = 1.obs;

  void goToNextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void goBack() {
    if (currentStep.value > 1) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    groupNameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    frequencyController.dispose();
    groupSizeController.dispose();
    super.onClose();
  }

}
