import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../Utils/AppIcons/app_icons.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(controller),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(controller.notifications[index]);
                },
              ),
            ),
          ),
          SizedBox(height: 100.h), // Space for bottom nav bar
        ],
      ),
    );
  }

  Widget _buildHeader(NotificationController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 24.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Obx(
            () => Text(
              '${controller.unreadCount.value} unread',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: notification.isUnread ? const Color(0xFF6773FF).withOpacity(0.3) : const Color(0xFFF1F5F9),
          width: 1.w,
        ),
        boxShadow: [
          if (notification.isUnread)
            BoxShadow(
              color: const Color(0xFF6773FF).withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIcon(notification.type),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      notification.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      notification.date,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
              if (notification.isUnread)
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A227F),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          SizedBox(height: 12.h),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'View Group',
                  style: TextStyle(
                    color: const Color(0xFF1A227F),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward,
                  size: 16.sp,
                  color: const Color(0xFF1A227F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(NotificationType type) {
    Color bgColor;
    Color iconColor;
    String iconPath;
    IconData? materialIcon;

    switch (type) {
      case NotificationType.payment:
        bgColor = const Color(0xFFDCFCE7);
        iconColor = const Color(0xFF22C55E);
        iconPath = "assets/icons/doller.svg";
        break;
      case NotificationType.reminder:
        bgColor = const Color(0xFFEEF2FF);
        iconColor = const Color(0xFF6366F1);
        materialIcon = Icons.calendar_today_outlined;
        iconPath = AppIcons.clIcons;
        break;
      case NotificationType.invitation:
        bgColor = const Color(0xFFF5F3FF);
        iconColor = const Color(0xFF8B5CF6);
        iconPath = AppIcons.groupsIcons;
        break;
    }

    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(12.r),
      child: materialIcon != null
          ? Icon(materialIcon, color: iconColor, size: 24.sp)
          : SvgPicture.asset(
              iconPath,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
    );
  }
}
