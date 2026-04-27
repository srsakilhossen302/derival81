import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Home/view/home_screen.dart';
import '../model/payment_method_model.dart';
import '../../../../../service/api_url.dart';

class PaymentMethodController extends GetxController {
  var isLinkingBank = false.obs;
  var isAddingCard = false.obs;

  var isLoading = false.obs;
  var isConnectLoading = false.obs;

  var isStripeConnected = false.obs;

  var savedMethods = <PaymentMethodModel>[].obs;

  final TextEditingController routingController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController accountHolderNameController = TextEditingController();

  CardFieldInputDetails? cardFieldInputDetails;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentMethods();
    checkStripeConnectStatus();
  }

  @override
  void onClose() {
    routingController.dispose();
    accountController.dispose();
    accountHolderNameController.dispose();
    super.onClose();
  }

  // --- Helpers ---

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // --- UI Toggles ---

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
    accountHolderNameController.clear();
  }

  // --- Payment Methods API ---

  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      final token = await _getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiUrl.paymentMethodsUrl),
        headers: _authHeaders(token),
      );

      debugPrint('[fetchPaymentMethods] status: ${response.statusCode}');
      debugPrint('[fetchPaymentMethods] body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns: { "success": true, "data": [...] }
        final List list = data['data'] ?? [];
        savedMethods.assignAll(
          list.map((item) => PaymentMethodModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      debugPrint('[fetchPaymentMethods] error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePaymentMethod(String id) async {
    try {
      isLoading.value = true;
      final token = await _getToken();
      if (token == null) {
        _showErrorSnackbar('Not authenticated');
        return;
      }

      final response = await http.delete(
        Uri.parse(ApiUrl.deletePaymentMethodUrl(id)),
        headers: _authHeaders(token),
      );

      debugPrint('[deletePaymentMethod] status: ${response.statusCode}');
      debugPrint('[deletePaymentMethod] body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        savedMethods.removeWhere((method) => method.id == id);
        Get.snackbar('Success', 'Payment method deleted',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        final body = jsonDecode(response.body);
        _showErrorSnackbar(body['message'] ?? 'Failed to delete payment method');
      }
    } catch (e) {
      debugPrint('[deletePaymentMethod] error: $e');
      _showErrorSnackbar('Failed to delete payment method');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitBankLink() async {
    final routingNum = routingController.text.trim();
    final accountNum = accountController.text.trim();
    final holderName = accountHolderNameController.text.trim();

    if (holderName.isEmpty) {
      _showErrorSnackbar('Please enter the account holder name');
      return;
    }
    if (routingNum.isEmpty || accountNum.length < 4) {
      _showErrorSnackbar('Please enter valid routing and account numbers');
      return;
    }

    try {
      isLoading.value = true;

      // Create real Stripe PM so backend Zod validation passes (requires paymentMethodId).
      // Backend MUST skip stripe.paymentMethods.attach() for type="bank" since
      // unverified bank accounts cannot be attached to a customer directly.
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.usBankAccount(
          paymentMethodData: PaymentMethodDataUsBank(
            accountNumber: accountNum,
            routingNumber: routingNum,
            accountHolderType: BankAccountHolderType.Individual,
            accountType: UsBankAccountType.Checking,
            billingDetails: BillingDetails(name: holderName),
          ),
        ),
      );

      debugPrint('[submitBankLink] pm_id: ${paymentMethod.id}');

      final success = await _sendPaymentMethodToBackend(
        paymentMethodId: paymentMethod.id,
        type: 'bank',
        isDefault: savedMethods.isEmpty,
      );

      if (success) {
        final String last4 = accountNum.substring(accountNum.length - 4);
        savedMethods.add(PaymentMethodModel(
          id: paymentMethod.id,
          type: 'bank',
          last4: last4,
          isDefault: savedMethods.isEmpty,
        ));
        Get.snackbar('Success', 'Bank account linked successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        cancelLinking();
      }
    } on StripeException catch (e) {
      debugPrint('[submitBankLink] StripeException: ${e.error.message}');
      _showErrorSnackbar(e.error.localizedMessage ?? 'Stripe Error');
    } catch (e) {
      debugPrint('[submitBankLink] error: $e');
      _showErrorSnackbar('Network error. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitCardLink() async {
    if (cardFieldInputDetails == null || !cardFieldInputDetails!.complete) {
      _showErrorSnackbar('Please enter valid card details');
      return;
    }

    try {
      isLoading.value = true;

      // Step 1: Create PaymentMethod via Stripe SDK
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      debugPrint('[submitCardLink] pm_id: ${paymentMethod.id}');

      // Step 2: Send pm_id to your backend
      final success = await _sendPaymentMethodToBackend(
        paymentMethodId: paymentMethod.id,
        type: 'card',
        isDefault: savedMethods.isEmpty,
      );

      if (success) {
        savedMethods.add(PaymentMethodModel(
          id: paymentMethod.id,
          type: 'card',
          last4: paymentMethod.card.last4 ?? '****',
          isDefault: savedMethods.length == 1,
        ));
        Get.snackbar('Success', 'Card added successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
        cancelLinking();
      }
    } on StripeException catch (e) {
      _showErrorSnackbar(e.error.localizedMessage ?? 'Stripe Error');
    } catch (e) {
      debugPrint('[submitCardLink] error: $e');
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _sendPaymentMethodToBackend({
    required String paymentMethodId,
    required String type,
    required bool isDefault,
  }) async {
    final token = await _getToken();
    if (token == null) {
      _showErrorSnackbar('Not authenticated. Please log in again.');
      return false;
    }

    final body = jsonEncode({
      "paymentMethodId": paymentMethodId,
      "type": type,           // "card" or "bank"
      "isDefault": isDefault,
      "autoPayEnabled": true,
    });

    debugPrint('[_sendPaymentMethodToBackend] POST ${ApiUrl.paymentMethodsUrl}');
    debugPrint('[_sendPaymentMethodToBackend] body: $body');

    try {
      final response = await http.post(
        Uri.parse(ApiUrl.paymentMethodsUrl),
        headers: _authHeaders(token),
        body: body,
      );

      debugPrint('[_sendPaymentMethodToBackend] status: ${response.statusCode}');
      debugPrint('[_sendPaymentMethodToBackend] response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        _showErrorSnackbar(data['message'] ?? 'Failed to save payment method');
        return false;
      }
    } catch (e) {
      debugPrint('[_sendPaymentMethodToBackend] error: $e');
      _showErrorSnackbar('Network error. Please try again.');
      return false;
    }
  }

  Future<void> setDefaultMethod(String id) async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await http.patch(
        Uri.parse(ApiUrl.setDefaultPaymentMethodUrl(id)),
        headers: _authHeaders(token),
      );

      debugPrint('[setDefaultMethod] status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final updated = savedMethods.map((m) {
          return m.copyWith(isDefault: m.id == id);
        }).toList();
        savedMethods.assignAll(updated);
      } else {
        final data = jsonDecode(response.body);
        _showErrorSnackbar(data['message'] ?? 'Failed to set default');
      }
    } catch (e) {
      debugPrint('[setDefaultMethod] error: $e');
      _showErrorSnackbar('Network error. Please try again.');
    }
  }

  // --- Stripe Connect (Payouts) ---

  Future<void> checkStripeConnectStatus() async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiUrl.stripeConnectStatusUrl),
        headers: _authHeaders(token),
      );

      debugPrint('[checkStripeConnectStatus] status: ${response.statusCode}');
      debugPrint('[checkStripeConnectStatus] body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        isStripeConnected.value = data['data']?['connected'] == true ||
            data['connected'] == true;
      }
    } catch (e) {
      debugPrint('[checkStripeConnectStatus] error: $e');
    }
  }

  Future<void> startStripeOnboarding() async {
    try {
      isConnectLoading.value = true;
      final token = await _getToken();
      if (token == null) {
        _showErrorSnackbar('Not authenticated');
        return;
      }

      final response = await http.post(
        Uri.parse(ApiUrl.stripeConnectAccountLinkUrl),
        headers: _authHeaders(token),
      );

      debugPrint('[startStripeOnboarding] status: ${response.statusCode}');
      debugPrint('[startStripeOnboarding] body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Backend returns the URL in data.data or data.url
        final String? link = data['data'] is String
            ? data['data']
            : data['data']?['url'] ?? data['url'];

        if (link != null && link.isNotEmpty) {
          await _launchURL(link);
        } else {
          _showErrorSnackbar('Invalid onboarding URL received');
        }
      } else {
        final data = jsonDecode(response.body);
        _showErrorSnackbar(data['message'] ?? 'Failed to start onboarding');
      }
    } catch (e) {
      debugPrint('[startStripeOnboarding] error: $e');
      _showErrorSnackbar('Failed to start Stripe onboarding');
    } finally {
      isConnectLoading.value = false;
    }
  }

  Future<void> accessPayoutDashboard() async {
    try {
      isConnectLoading.value = true;
      final token = await _getToken();
      if (token == null) {
        _showErrorSnackbar('Not authenticated');
        return;
      }

      final response = await http.get(
        Uri.parse(ApiUrl.stripeConnectLoginLinkUrl),
        headers: _authHeaders(token),
      );

      debugPrint('[accessPayoutDashboard] status: ${response.statusCode}');
      debugPrint('[accessPayoutDashboard] body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? link = data['data'] is String
            ? data['data']
            : data['data']?['url'] ?? data['url'];

        if (link != null && link.isNotEmpty) {
          await _launchURL(link);
        } else {
          _showErrorSnackbar('Invalid dashboard URL received');
        }
      } else {
        final data = jsonDecode(response.body);
        _showErrorSnackbar(data['message'] ?? 'Failed to open dashboard');
      }
    } catch (e) {
      debugPrint('[accessPayoutDashboard] error: $e');
      _showErrorSnackbar('Failed to open payout dashboard');
    } finally {
      isConnectLoading.value = false;
    }
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackbar('Could not open link');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  void skipForNow() {
    Get.offAll(() => HomeScreen());
  }

  void continueToDashboard() {
    Get.offAll(() => HomeScreen());
  }
}
