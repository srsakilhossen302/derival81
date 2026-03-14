import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Utils/AppIcons/app_icons.dart';
import '../../../../Widgegt/custom_textfield.dart';
import '../controller/complete_profile_controller.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({Key? key}) : super(key: key);

  final CompleteProfileController controller = Get.put(CompleteProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      color: Color(0xFFF1F5F9), // Light greyish background for icon
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.appsIcons, // Reusing from the sign up screen
                        height: 32,
                        width: 32,
                        colorFilter: const ColorFilter.mode(Color(0xFF1A227F), BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Complete your profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Help us know you better',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A5565),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),

              // Profile Image Upload Component
              Center(
                child: GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Obx(() => Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9), // Background color when no image
                                  shape: BoxShape.circle,
                                  image: controller.imagePath.value.isNotEmpty
                                      ? DecorationImage(
                                          image: FileImage(File(controller.imagePath.value)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: controller.imagePath.value.isEmpty
                                    ? Center(
                                        child: SvgPicture.asset(
                                          AppIcons.profileIcons,
                                          height: 40,
                                          width: 40,
                                          colorFilter: const ColorFilter.mode(Color(0xFF94A3B8), BlendMode.srcIn),
                                        ),
                                      )
                                    : null,
                              )),
                          // Upload Icon Button
                          Container(
                            height: 28,
                            width: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1A227F), // Main blue color
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppIcons.dwIcons,
                                height: 16,
                                width: 16,
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Upload profile picture',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8), // Muted grey color
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Form fields
              CustomTextField(
                label: 'Date of Birth',
                hintText: '',
                controller: controller.dobController,
                readOnly: true,
                onTap: () => controller.pickDate(context),
                prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF94A3B8)),
              ),
              CustomTextField(
                label: 'Occupation',
                hintText: 'Enter your occupation',
                controller: controller.occupationController,
                prefixIcon: SvgPicture.asset(
                  AppIcons.profileIcons, // Fallback using profile icon
                  colorFilter: const ColorFilter.mode(Color(0xFF94A3B8), BlendMode.srcIn),
                  height: 20,
                  width: 20,
                ),
              ),
              CustomTextField(
                label: 'Street address',
                hintText: 'Enter your address',
                controller: controller.addressController,
                prefixIcon: SvgPicture.asset(
                  AppIcons.locationIcons, // Location icon from AppIcons
                  colorFilter: const ColorFilter.mode(Color(0xFF94A3B8), BlendMode.srcIn),
                  height: 20,
                  width: 20,
                ),
              ),
              CustomTextField(
                label: 'City',
                hintText: 'City',
                controller: controller.cityController,
              ),
              CustomTextField(
                label: 'State',
                hintText: 'State',
                controller: controller.stateController,
              ),
              CustomTextField(
                label: 'ZIP Code',
                hintText: 'ZIP',
                controller: controller.zipController,
              ),

              const SizedBox(height: 24),

              // Continue Button
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.submitProfile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A227F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  )),

              const SizedBox(height: 16),

              // Skip for now Action
              Obx(() => controller.isLoading.value 
                ? const SizedBox.shrink()
                : Center(
                    child: TextButton(
                      onPressed: () => controller.skipForNow(),
                      child: const Text(
                        'Skip for now',
                        style: TextStyle(
                          color: Color(0xFF4A5565),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
