import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/custom_textfield.dart';
import '../controller/payment_method_controller.dart';

class PaymentMethodScreen extends StatelessWidget {
  PaymentMethodScreen({Key? key}) : super(key: key);

  final PaymentMethodController controller = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Custom Header Row
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                            onPressed: () => Get.back(),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                        Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppIcons.appsIcons,
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Title
                    const Text(
                      'Link your payment method',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'Add a bank account or card for\nautomatic contributions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5565),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Reactive Body
                    Obx(() {
                      if (controller.isLinkingBank.value) {
                        return _buildBankLinkForm();
                      } else if (controller.isAddingCard.value) {
                        return _buildCardLinkForm();
                      } else {
                        return _buildInitialOptions();
                      }
                    }),

                    const SizedBox(height: 32),

                    // Security Info Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Text('🔒', style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your banking information is encrypted and secure. We use bank-level security to protect your data.',
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFF4A5565).withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Skip Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.skipForNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E8F0),
                    foregroundColor: const Color(0xFF4A5565),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialOptions() {
    return Column(
      children: [
        _buildPaymentOption(
          icon: AppIcons.bankIcons,
          title: 'Link Bank Account',
          onTap: () => controller.linkBankAccount(),
        ),
        const SizedBox(height: 16),
        _buildPaymentOption(
          icon: AppIcons.debitCreditCardIcon,
          title: 'Add Debit/Credit Card',
          onTap: () => controller.addCreditCard(),
        ),
      ],
    );
  }

  Widget _buildBankLinkForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Link Bank Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Routing Number',
          hintText: 'Enter routing number',
          controller: controller.routingController,
        ),
        CustomTextField(
          label: 'Account Number',
          hintText: 'Enter account number',
          controller: controller.accountController,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.submitBankLink(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A227F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Link Account'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.cancelLinking(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2E8F0),
                  foregroundColor: const Color(0xFF4A5565),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardLinkForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Add Card',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Card Number',
          hintText: '1234 5678 9012 3456',
          controller: controller.cardNumberController,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'Expiry Date',
                hintText: 'MM/YY',
                controller: controller.expiryController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'CVV',
                hintText: '123',
                controller: controller.cvvController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.submitCardLink(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A227F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add Card'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => controller.cancelLinking(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2E8F0),
                  foregroundColor: const Color(0xFF4A5565),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(Color(0xFF94A3B8), BlendMode.srcIn),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A5565),
                ),
              ),
            ),
            const Icon(
              Icons.add,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
