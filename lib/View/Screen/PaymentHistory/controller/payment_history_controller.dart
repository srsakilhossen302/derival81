import 'package:get/get.dart';
import '../model/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  var selectedFilter = 'All'.obs;
  final List<String> filters = ['All', 'Completed', 'Pending', 'Failed'];

  // Empty list as shown in the screenshot ("No payments found")
  var payments = <PaymentHistoryModel>[].obs;

  double get totalContributed {
    if (payments.isEmpty) return 0.0;
    return payments.fold(0, (sum, item) => sum + item.amount);
  }

  int get paymentsCount => payments.length;

  List<PaymentHistoryModel> get filteredPayments {
    if (selectedFilter.value == 'All') {
      return payments;
    }
    return payments.where((p) => p.status == selectedFilter.value).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
