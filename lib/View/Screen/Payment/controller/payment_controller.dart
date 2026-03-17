import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../model/payment_method_model.dart';

class PaymentController extends GetxController {
  // Observable variables
  var thisMonthSpent = 0.obs;
  var pendingPayments = 0.obs;
  
  // List of payment methods
  var paymentMethods = <PaymentMethodModel>[
    PaymentMethodModel(
      id: '1',
      name: 'Bank Account',
      lastDigits: '****1234',
      iconPath: AppIcons.bankIcons,
      isDefault: true,
    ),
    PaymentMethodModel(
      id: '2',
      name: 'Credit Card',
      lastDigits: '****5678',
      iconPath: AppIcons.debitCreditCardIcon,
      isDefault: false,
    ),
  ].obs;

  // Method to handle adding a new payment method
  void addNewPaymentMethod() {
    // Logic to navigate to add payment method screen or show dialog
    Get.snackbar('Coming Soon', 'Add Payment Method feature is under development');
  }

  // Method to select a payment method
  void selectPaymentMethod(String id) {
    // Logic to set default payment method
     // This is just a simulation, in a real app this would likely update the backend
     var newMethods = paymentMethods.map((method) {
        return PaymentMethodModel(
          id: method.id,
          name: method.name,
          lastDigits: method.lastDigits,
          iconPath: method.iconPath,
          isDefault: method.id == id,
        );
     }).toList();
     paymentMethods.assignAll(newMethods);
  }
}
