import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  
  var currentStep = 1.obs;

  void goToNextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  @override
  void onClose() {
    groupNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
