import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Utils/AppIcons/app_icons.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: bottomPadding > 0 ? bottomPadding + 8 : 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A227F),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(0, AppIcons.homeNavBar, 'Home'),
          _buildNavBarItem(1, AppIcons.groupNavBar, 'Groups'),
          _buildNavBarItem(2, AppIcons.paymentNavBar, 'Payment'),
          _buildNavBarItem(3, AppIcons.notificationNavBar, 'Alerts'),
          _buildNavBarItem(4, AppIcons.profileNavBar, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(int index, String iconPath, String label) {
    bool isSelected = currentIndex == index;

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 18,
              width: 18,
              colorFilter: const ColorFilter.mode(Color(0xFF1A227F), BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1A227F),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            iconPath,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.srcIn),
          ),
        ),
      );
    }
  }
}
