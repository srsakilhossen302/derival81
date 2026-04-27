import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Auth/payment_method/model/payment_method_model.dart';
import '../../../../service/api_url.dart';

class PaymentController extends GetxController {
  var thisMonthSpent = 0.obs;
  var pendingPayments = 0.obs;
  var isLoading = false.obs;

  // Uses the same model as PaymentMethodController
  var paymentMethods = <PaymentMethodModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      final token = await _getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiUrl.paymentMethodsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('[PaymentController.fetchPaymentMethods] status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns: { "success": true, "data": [...] }
        final List list = data['data'] ?? [];
        paymentMethods.assignAll(
          list.map((item) => PaymentMethodModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      debugPrint('[PaymentController.fetchPaymentMethods] error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPaymentMethod(String id) {
    final updated = paymentMethods.map((method) {
      return method.copyWith(isDefault: method.id == id);
    }).toList();
    paymentMethods.assignAll(updated);
    // Optionally call PATCH API here to persist default on backend
  }
}
