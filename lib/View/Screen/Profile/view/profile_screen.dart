import 'package:derival81/Utils/AppIcons/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Language/view/language_selection_screen.dart';
import '../../Language/controller/language_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(controller),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  _buildPersonalInfoCard(controller),
                  const SizedBox(height: 24),
                  _buildSecuritySettingsCard(controller),
                  const SizedBox(height: 24),
                  _buildSupportCard(),
                  const SizedBox(height: 32),
                  _buildLogoutButton(controller),
                  const SizedBox(height: 24),
                  Obx(
                    () => Text(
                      'Version ${controller.appVersion.value}',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 120), // Bottom navbar padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 32),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.5, -0.6),
          radius: 1.2,
          colors: [Color(0xFF6773FF), Color(0xFF1A227F)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 46,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
              ),
              backgroundColor: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Text(
              controller.userName.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              controller.userEmail.value,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoTile(
            iconPath: AppIcons.messgIcons,
            title: 'email'.tr,
            subtitle: Obx(
              () => Text(
                controller.userEmail.value,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ),
            trailingIconPath: '', // No chevron for static info
            trailingColor: Colors.transparent,
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildInfoTile(
            iconPath: AppIcons.phoneIcons,
            title: 'phone'.tr,
            subtitle: Obx(
              () => Text(
                controller.userPhone.value,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ),
            trailingIconPath: '',
            trailingColor: Colors.transparent,
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildInfoTile(
            iconPath: AppIcons.debitCreditCardIcon,
            title: 'payment_methods'.tr,
            subtitle: Obx(
              () => Text(
                '${controller.linkedPaymentMethodsCount.value} ${'linked'.tr}',
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ),
            trailingIconPath: AppIcons.dwIcons,
            trailingColor: const Color(0xFF94A3B8),
            isSubtitleSmaller: true,
            onTap: () {
              // Navigate to Payment Methods screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettingsCard(ProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'security_settings'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildInfoTile(
            iconPath: AppIcons.twoFactorIcons,
            title: 'two_factor'.tr,
            subtitle: Obx(
              () => Text(
                controller.twoFactorEnabled.value
                    ? 'enabled'.tr
                    : 'disabled'.tr,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ),
            trailingIconPath: AppIcons.dwIcons, // Placeholder for chevron
            trailingColor: const Color(0xFF94A3B8),
            isSubtitleSmaller: true,
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildInfoTile(
            iconPath: AppIcons
                .appsIcons, // Using apps icon as placeholder for language
            title: 'language'.tr,
            subtitle: Obx(() {
              final languageCode = Get.find<LanguageController>()
                  .currentLocale
                  .value
                  .languageCode;
              String languageName = 'English';
              if (languageCode == 'es') languageName = 'Español';
              if (languageCode == 'fr') languageName = 'Français';
              if (languageCode == 'ht') languageName = 'Kreyòl Ayisyen';
              return Text(
                languageName,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
              );
            }),
            trailingIconPath: AppIcons.dwIcons,
            trailingColor: const Color(0xFF94A3B8),
            isSubtitleSmaller: true,
            onTap: () {
              Get.to(() => LanguageSelectionScreen(isFirstTime: false));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'support'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          _buildSimpleTile(
            iconPath: AppIcons.helpIcons,
            title: 'help_center'.tr,
            onTap: () {},
          ),
          const SizedBox(height: 8), // small space
          _buildSimpleTile(
            iconPath: AppIcons.termsIcons,
            title: 'terms_privacy'.tr,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(ProfileController controller) {
    return InkWell(
      onTap: controller.logout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.logoutIcons,
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFFEF4444),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'logout'.tr,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required String iconPath,
    required String title,
    required Widget subtitle,
    required String trailingIconPath,
    required Color trailingColor,
    required VoidCallback onTap,
    bool isSubtitleSmaller = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Color(0xFF64748B),
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSubtitleSmaller
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF64748B),
                      fontSize: isSubtitleSmaller ? 16 : 14,
                      fontWeight: isSubtitleSmaller
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  subtitle,
                ],
              ),
            ),
            if (trailingIconPath.isNotEmpty)
              SvgPicture.asset(
                trailingIconPath,
                colorFilter: ColorFilter.mode(trailingColor, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Color(0xFF64748B),
                BlendMode.srcIn,
              ),
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }
}
