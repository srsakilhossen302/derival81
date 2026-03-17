import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
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
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80'),
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
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
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
            title: 'Email',
            subtitle: Obx(() => Text(
                  controller.userEmail.value,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            trailingIconPath: AppIcons.editIcons,
            trailingColor: const Color(0xFF1A227F),
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildInfoTile(
            iconPath: AppIcons.phoneIcons,
            title: 'Phone',
            subtitle: Obx(() => Text(
                  controller.userPhone.value,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            trailingIconPath: AppIcons.editIcons,
            trailingColor: const Color(0xFF1A227F),
            onTap: () {},
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildInfoTile(
            iconPath: AppIcons.paymentNavBar,
            title: 'Payment Methods',
            subtitle: Obx(() => Text(
                  '${controller.linkedPaymentMethodsCount.value} linked',
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            trailingIconPath: AppIcons.rtIcons, // We don't have a correct chevron, using rtIcons temporarily but typically we'll change it later if we need. Wait let me change the implementation
            trailingColor: const Color(0xFF94A3B8),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettingsCard(ProfileController controller) {
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Security & Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          _buildInfoTile(
            iconPath: AppIcons.twoFactorIcons,
            title: 'Two-Factor Authentication',
            subtitle: Obx(() => Text(
                  controller.twoFactorEnabled.value ? 'Enabled' : 'Disabled',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                )),
            trailingIconPath: AppIcons.dwIcons, // Placeholder for chevron
            trailingColor: const Color(0xFF94A3B8),
            isSubtitleSmaller: true,
            onTap: () {},
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          _buildSimpleTile(
            iconPath: AppIcons.helpIcons,
            title: 'Help Center',
            onTap: () {},
          ),
          const SizedBox(height: 8), // small space
          _buildSimpleTile(
            iconPath: AppIcons.termsIcons,
            title: 'Terms & Privacy',
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
            SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
            SvgPicture.asset(iconPath, colorFilter: const ColorFilter.mode(Color(0xFF64748B), BlendMode.srcIn), width: 24, height: 24),
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
            SvgPicture.asset(trailingIconPath, colorFilter: ColorFilter.mode(trailingColor, BlendMode.srcIn), width: 20, height: 20),
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
            SvgPicture.asset(iconPath, colorFilter: const ColorFilter.mode(Color(0xFF64748B), BlendMode.srcIn), width: 24, height: 24),
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
