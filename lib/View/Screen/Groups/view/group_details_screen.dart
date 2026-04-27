import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../controller/group_controller.dart';
import '../model/group_model.dart';
import '../model/group_member_model.dart';
import 'group_chat_screen.dart';
import '../../../Widgegt/invite_dialog.dart';


class GroupDetailsScreen extends StatelessWidget {
  final GroupModel group;

  const GroupDetailsScreen({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  _buildStatusCard(),
                  SizedBox(height: 20.h),
                  _buildStatCards(),
                  SizedBox(height: 20.h),
                  _buildTurnQueue(),
                  SizedBox(height: 20.h),
                  _buildAdminControls(context),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 50.h, 24.w, 32.h),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment(0.5, -0.6),
          radius: 1.2,
          colors: [
            Color(0xFF6773FF),
            Color(0xFF1A227F),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(width: 8.w),
              Text(
                '${group.name}.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: _buildHeaderBtn(
                  AppIcons.inviteIcons,
                  'Invite',
                  onTap: () => _showInviteDialog(context),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildHeaderBtn(
                  AppIcons.chatIcons,
                  'Chat',
                  onTap: () => Get.to(() => GroupChatScreen(group: group)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBtn(String iconPath, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              height: 20.h,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9C3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Pending',
              style: TextStyle(
                color: const Color(0xFF854D0E),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            group.description,
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Contribution',
            '\$${group.amount.toInt()}',
            'per monthly',
            iconPath: AppIcons.dollerIcon,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            'Members',
            '${group.membersCount}/${group.totalMembers}',
            null,
            iconPath: AppIcons.groupsIcons,
            progress: group.progress,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String? subtitle, {
    IconData? icon,
    String? iconPath,
    double? progress,
  }) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath,
                  height: 18.h,
                  width: 18.w,
                  colorFilter: const ColorFilter.mode(Color(0xFF94A3B8), BlendMode.srcIn),
                )
              else if (icon != null)
                Icon(icon, color: const Color(0xFF94A3B8), size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 12.sp,
              ),
            ),
          ],
          if (progress != null) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1A227F)),
                minHeight: 6.h,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTurnQueue() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Turn Queue',
                style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Round 0',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildQueueHighlightBox(),
          SizedBox(height: 16.h),
          ...group.members.map((member) => _buildMemberItem(member)).toList(),
        ],
      ),
    );
  }

  Widget _buildQueueHighlightBox() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your position:',
                style: TextStyle(
                  color: const Color(0xFF475569),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Next payment: ${group.nextDate}',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Text(
            '#${group.position}',
            style: TextStyle(
              color: const Color(0xFF1A227F),
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(GroupMemberModel member, {bool isYou = false}) {
    bool isFirst = member.position == 1;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: Color(0xFF818CF8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(member.position.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.fullName,
                        style: TextStyle(
                          color: const Color(0xFF0F172A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isFirst) ...[
                        SizedBox(width: 4.w),
                        SvgPicture.asset(AppIcons.mukutIcon, height: 16.h),
                      ],
                      if (isYou) ...[
                        SizedBox(width: 4.w),
                        Text(
                          '(You)',
                          style: TextStyle(
                            color: const Color(0xFF6366F1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Contributed: \$${member.totalPaidAmount.toInt()} / ${group.totalMembers} Months',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
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

  Widget _buildAdminControls(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Controls',
            style: TextStyle(
              color: const Color(0xFF0F172A),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          _buildAdminBtn(
            'View Invite Code',
            const Color(0xFFEEF2FF),
            const Color(0xFF1A227F),
            icon: null,
            onTap: () => _showInviteDialog(context),
          ),
          SizedBox(height: 12.h),
          _buildAdminBtn(
            'Delete Group',
            const Color(0xFFFEF2F2),
            const Color(0xFFEF4444),
            iconPath: AppIcons.deleteGroupIcons,
            onTap: () => _showDeleteDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminBtn(String label, Color bgColor, Color textColor, {IconData? icon, String? iconPath, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null) ...[
              SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                height: 20.h,
              ),
              SizedBox(width: 8.w),
            ] else if (icon != null) ...[
              Icon(icon, color: textColor, size: 20.sp),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete Group?',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'This action cannot be undone. All group data will be permanently deleted.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Actual delete logic
                          final groupController = Get.find<GroupController>();
                          groupController.deleteGroup(group.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE2E8F0),
                          foregroundColor: const Color(0xFF475569),
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showInviteDialog(BuildContext context) {
    InviteDialog.show(context, groupName: group.name, inviteCode: 'YRSS496ZBG');
  }
}
