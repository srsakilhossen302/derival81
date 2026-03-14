import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/custom_textfield.dart';
import '../controller/set_password_controller.dart';

class SetPasswordScreen extends StatelessWidget {
  SetPasswordScreen({Key? key}) : super(key: key);

  final SetPasswordController controller = Get.put(SetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Logo/Icon Container
              Center(
                child: Container(
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
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Set Password for Savings',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              const Text(
                'Start saving with your friends and family.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A5565),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),

              // Input Fields
              CustomTextField(
                label: 'New Password',
                hintText: '76543',
                controller: controller.newPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Confirm New Password',
                hintText: '76543',
                controller: controller.confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.savePassword(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A227F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
