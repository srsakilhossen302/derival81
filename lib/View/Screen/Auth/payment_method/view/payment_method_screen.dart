import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/custom_textfield.dart';
import '../controller/payment_method_controller.dart';
import '../model/payment_method_model.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
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
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF0F172A),
                            ),
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
                    Text(
                      'link_payment_title'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'link_payment_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A5565),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Saved Methods Section
                    Obx(
                      () => controller.savedMethods.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saved Payment Methods',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...controller.savedMethods
                                    .map((method) => _buildSavedMethodCard(method))
                                    .toList(),
                                const SizedBox(height: 8),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Reactive Body (Form or Initial Options)
                    Obx(() {
                      if (controller.isLinkingBank.value) {
                        return _buildBankLinkForm();
                      } else if (controller.isAddingCard.value) {
                        return _buildCardLinkForm();
                      } else {
                        return Column(
                          children: [
                            _buildPaymentOption(
                              icon: AppIcons.bankIcons,
                              title: 'link_bank'.tr,
                              onTap: () => controller.linkBankAccount(),
                            ),
                            const SizedBox(height: 16),
                            _buildPaymentOption(
                              icon: AppIcons.debitCreditCardIcon,
                              title: 'add_card'.tr,
                              onTap: () => controller.addCreditCard(),
                            ),
                          ],
                        );
                      }
                    }),

                    const SizedBox(height: 32),

                    const SizedBox(height: 32),

                    // Stripe Connect / Payouts Section
                    Obx(() => Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payout Settings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.isStripeConnected.value 
                                  ? 'Your account is connected to Stripe.'
                                  : 'Connect your account to receive payouts.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4A5565),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: controller.isConnectLoading.value
                                      ? null
                                      : () {
                                          if (controller.isStripeConnected.value) {
                                            controller.accessPayoutDashboard();
                                          } else {
                                            controller.startStripeOnboarding();
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: controller.isStripeConnected.value ? const Color(0xFFE2E8F0) : const Color(0xFF6773FF),
                                    foregroundColor: controller.isStripeConnected.value ? const Color(0xFF0F172A) : Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: controller.isConnectLoading.value
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                      : Text(controller.isStripeConnected.value ? 'View Payout Dashboard' : 'Connect Stripe Account'),
                                ),
                              ),
                            ],
                          ),
                        )),
                    
                    const SizedBox(height: 24),

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
                              'security_note'.tr,
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

            // Bottom Actions (Conditional)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Obx(
                    () => controller.savedMethods.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => controller.continueToDashboard(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1A227F),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Continue to Dashboard',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedMethodCard(PaymentMethodModel method) {
    final isBank = method.type == 'bank';
    final icon = isBank ? AppIcons.bankIcons : AppIcons.debitCreditCardIcon;
    final title = isBank ? 'bank_account'.tr : 'credit_card'.tr;
    
    return GestureDetector(
      onTap: () => controller.setDefaultMethod(method.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: method.isDefault ? const Color(0xFFF0FDF4) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: method.isDefault ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: SvgPicture.asset(
                icon,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  method.isDefault ? const Color(0xFF22C55E) : const Color(0xFF94A3B8),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '****${method.last4}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4A5565),
                    ),
                  ),
                ],
              ),
            ),
            if (method.isDefault)
              const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 24)
            else
              const Icon(Icons.circle_outlined, color: Color(0xFFE2E8F0), size: 24),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => controller.deletePaymentMethod(method.id),
              child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
            ),
          ],
        ),
      ),
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
              colorFilter: const ColorFilter.mode(
                Color(0xFF94A3B8),
                BlendMode.srcIn,
              ),
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
            const Icon(Icons.add, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
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
          label: 'Account Holder Name',
          hintText: 'Enter full name',
          controller: controller.accountHolderNameController,
        ),
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
        // Buttons
        Obx(() => Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.submitBankLink(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A227F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Link Account'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.cancelLinking(),
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
        )),
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
        
        // Stripe Card Field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: CardField(
            onCardChanged: (card) {
              controller.cardFieldInputDetails = card;
            },
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Buttons
        Obx(() => Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.submitCardLink(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A227F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Add Card'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.cancelLinking(),
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
        )),
      ],
    );
  }
}
