import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Home/view/home_screen.dart';

class PaymentMethodController extends GetxController {
  var isLinkingBank = false.obs;
  var isAddingCard = false.obs;

  // Track if methods are added
  var isBankAdded = false.obs;
  var isCardAdded = false.obs;

  // Display values
  var bankLast4 = "".obs;
  var cardLast4 = "".obs;

  final TextEditingController routingController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  void onClose() {
    routingController.dispose();
    accountController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
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
    cardNumberController.clear();
    expiryController.clear();
    cvvController.clear();
  }

  void submitBankLink() {
    if (routingController.text.isNotEmpty && accountController.text.length >= 4) {
      isBankAdded.value = true;
      bankLast4.value = accountController.text.substring(accountController.text.length - 4);
      cancelLinking();
    }
  }

  void submitCardLink() {
    if (cardNumberController.text.length >= 4) {
      isCardAdded.value = true;
      cardLast4.value = cardNumberController.text.substring(cardNumberController.text.length - 4);
      cancelLinking();
    }
  }

  void skipForNow() {
    Get.offAll(() => HomeScreen());
  }

  void continueToDashboard() {
    Get.offAll(() => HomeScreen());
  }
}
