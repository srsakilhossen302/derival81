import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = 'Jerin'.obs;
  final userEmail = 'ibrahim1@gmail.com'.obs;
  final userPhone = '+66-45678978'.obs;
  final twoFactorEnabled = false.obs;
  final appVersion = '1.0.0'.obs;
  final linkedPaymentMethodsCount = 2.obs;

  void logout() {
    // Add logout logic here
    Get.snackbar("Logout", "Logging out...");
  }
}
