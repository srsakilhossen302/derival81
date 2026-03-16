import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../model/group_model.dart';

class ActiveGroupDetailsScreen extends StatelessWidget {
  final GroupModel group;

  const ActiveGroupDetailsScreen({Key? key, required this.group}) : super(key: key);

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
                '${group.name}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
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
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBtn(String iconPath, String label, {VoidCallback? onTap}) {
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
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Active',
              style: TextStyle(
                color: const Color(0xFF166534),
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

  Widget _buildStatCard(String title, String value, String? subtitle, {String? iconPath, double? progress}) {
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
                ),
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
                'Round 1',
                style: TextStyle(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildMemberItem(1, 'John Doe', isYou: true, isFirst: true, isCompleted: true),
          _buildMemberItem(2, 'Jane Smith', isCompleted: true),
          _buildMemberItem(3, 'Mike Johnson', isCompleted: false),
        ],
      ),
    );
  }

  Widget _buildMemberItem(int rank, String name, {bool isYou = false, bool isFirst = false, bool isCompleted = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16.r),
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
                child: Text(
                  rank.toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
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
                        name,
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
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Contributed: \$1500 / 5 Months',
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isCompleted ? Icons.check_circle_outline : Icons.access_time,
              color: isCompleted ? const Color(0xFF22C55E) : const Color(0xFF6366F1),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Container(
            width: 361.w,
            height: 288.h,
            padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite Members',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Share this code with people you want to invite:',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'FAM2026XYZ',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A227F),
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () {
                          Get.snackbar(
                            '',
                            '',
                            titleText: Row(
                              children: [
                                Icon(Icons.check_circle, color: const Color(0xFF166534), size: 18.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Invite message copied to clipboard!',
                                    style: TextStyle(
                                      color: const Color(0xFF166534),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            messageText: const SizedBox.shrink(),
                            backgroundColor: const Color(0xFFF0FDF4),
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            borderRadius: 12.r,
                            duration: const Duration(seconds: 2),
                            isDismissible: true,
                            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                            borderColor: const Color(0xFFBBF7D0),
                            borderWidth: 1,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.copy_outlined, size: 16.sp, color: const Color(0xFF64748B)),
                            SizedBox(width: 6.w),
                            Text(
                              'Copy Code',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A227F),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Share',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE2E8F0).withOpacity(0.8),
                          foregroundColor: const Color(0xFF475569),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
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
}
