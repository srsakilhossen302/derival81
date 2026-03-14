import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  var isLinkingBank = false.obs;
  var isAddingCard = false.obs;

  final TextEditingController routingController = TextEditingController();
  final TextEditingController accountController = TextEditingController();

  @override
  void onClose() {
    routingController.dispose();
    accountController.dispose();
    super.onClose();
  }

  void linkBankAccount() {
    isLinkingBank.value = true;
    isAddingCard.value = false;
  }

  void addCreditCard() {
    isAddingCard.value = true;
    isLinkingBank.value = false;
  }

  void cancelLinking() {
    isLinkingBank.value = false;
    isAddingCard.value = false;
    routingController.clear();
    accountController.clear();
  }

  void submitBankLink() {
    // Logic to submit bank linking
  }

  void skipForNow() {
    // Logic for skip
  }
}
