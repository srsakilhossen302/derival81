import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          _buildBody(),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildMyGroupsSection(),
          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      constraints: const BoxConstraints(minHeight: 249),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.5, -0.6),
          radius: 1.2,
          colors: [
            Color(0xFF6773FF), // Light blue glow
            Color(0xFF1A227F), // Deep blue base
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Obx(() => Text(
                        controller.userName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AppIcons.groupsIcons,
                      height: 24,
                      width: 24,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24), // Gap from design
          Row(
            children: [
              Expanded(
                child: _buildHeaderStatCard(
                  label: 'Total Saved',
                  value: '\$${controller.totalSaved.value}',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHeaderStatCard(
                  label: 'Active Groups',
                  value: '${controller.activeGroups.value}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStatCard({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  label: 'Create Group',
                  icon: Icons.add,
                  color: const Color(0xFF1A227F),
                  bgColor: const Color(0xFFEEF2FF),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  label: 'Join Group',
                  icon: Icons.group_add_outlined,
                  color: const Color(0xFF00A63E),
                  bgColor: const Color(0xFFF0FDF4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String label,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF4A5565),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyGroupsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Groups',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(color: Color(0xFF1A227F)),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppIcons.groupsIcons,
                  height: 48,
                  width: 48,
                  colorFilter: ColorFilter.mode(
                    const Color(0xFF94A3B8).withOpacity(0.5),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "You haven't joined any groups yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A227F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Create Your First Group'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A227F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(0, AppIcons.homeNavBar, 'Home'),
            _buildNavBarItem(1, AppIcons.groupNavBar, ''),
            _buildNavBarItem(2, AppIcons.paymentNavBar, ''),
            _buildNavBarItem(3, AppIcons.notificationNavBar, ''),
            _buildNavBarItem(4, AppIcons.profileNavBar, ''),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem(int index, String iconPath, String label) {
    return Obx(() {
      bool isSelected = controller.selectedIndex.value == index;
      if (isSelected && label.isNotEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: 20,
                width: 20,
                colorFilter: const ColorFilter.mode(Color(0xFF1A227F), BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF1A227F),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      } else {
        return GestureDetector(
          onTap: () => controller.changeTabIndex(index),
          child: SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
          ),
        );
      }
    });
  }
}
