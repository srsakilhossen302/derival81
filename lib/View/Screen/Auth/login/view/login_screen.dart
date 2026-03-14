import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/custom_textfield.dart';
import '../controller/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final LoginController controller = Get.put(LoginController());

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
              const SizedBox(height: 40),
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
                'Log In For Savings',
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
                label: 'Email or phone number',
                hintText: 'email@example.com',
                controller: controller.emailController,
              ),
              const SizedBox(height: 4),

              CustomTextField(
                label: 'Password',
                hintText: '76543',
                controller: controller.passwordController,
                isPassword: true,
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF1A227F),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Log In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.login(),
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
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/sign-up'),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF1A227F),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFF1F5F9))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF94A3B8).withOpacity(0.8),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFF1F5F9))),
                ],
              ),
              const SizedBox(height: 32),

              // Social Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildSocialButton(
                      label: 'Google',
                      icon: AppIcons.googleIcons,
                      onTap: () => controller.loginWithGoogle(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSocialButton(
                      label: 'Facebook',
                      icon: AppIcons.facebookIcons,
                      onTap: () => controller.loginWithFacebook(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 24, width: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
