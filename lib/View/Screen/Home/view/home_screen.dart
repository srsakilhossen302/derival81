import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../../../Widgegt/custom_bottom_nav_bar.dart';
import '../controller/home_controller.dart';
import '../../Notification/view/notification_screen.dart';
import '../../Groups/view/group_screen.dart';
import '../../Groups/controller/group_controller.dart';
import '../../Groups/view/create_group_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final GroupController groupController = Get.put(GroupController());

  final List<Widget> _pages = [
    const _HomeView(),
    const GroupScreen(),
    const Center(
      child: Text(
        'Payment Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const NotificationScreen(),
    const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Obx(() => _pages[controller.selectedIndex.value]),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(
              () => CustomBottomNavBar(
                currentIndex: controller.selectedIndex.value,
                onTap: (index) => controller.changeTabIndex(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final GroupController groupController = Get.find<GroupController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(controller),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildMyGroupsSection(groupController),
          const SizedBox(height: 120), // Extra space for custom nav bar
        ],
      ),
    );
  }

  Widget _buildHeader(HomeController controller) {
    return Container(
      constraints: const BoxConstraints(minHeight: 249),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0.5, -0.6),
          radius: 1.2,
          colors: [Color(0xFF6773FF), Color(0xFF1A227F)],
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
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Obx(
                    () => Text(
                      controller.userName.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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
          const SizedBox(height: 24),
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
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                child: GestureDetector(
                  onTap: () => Get.to(() => const CreateGroupScreen()),
                  child: _buildActionCard(
                    label: 'Create Group',
                    iconPath: AppIcons.plasIcons,
                    color: const Color(0xFF1A227F),
                    bgColor: const Color(0xFFEEF2FF),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionCard(
                  label: 'Join Group',
                  iconPath: AppIcons.groupsIcons,
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
    required String iconPath,
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              height: 28,
              width: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4A5565),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyGroupsSection(GroupController groupController) {
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
          Obx(() {
            if (groupController.groups.isEmpty) {
              return Container(
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
                      style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Get.to(() => const CreateGroupScreen()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A227F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Create Your First Group'),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: groupController.groups.map((group) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  color: Color(0xFF166534),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.groups_outlined, size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  '${group.membersCount}/${group.totalMembers} members',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF64748B)),
                                const SizedBox(width: 6),
                                Text(
                                  'Position ${group.position}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${group.amount.toInt()}/monthly',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Next: ${group.nextDate}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: group.progress,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A227F)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          }),
        ],
      ),
    );
  }
}
