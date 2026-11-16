import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/features/shell/home_controller.dart';


class HomeShell extends GetView<HomeController> {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    controller.syncWithRoute(Get.currentRoute);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          border: const Border(
            top: BorderSide(color: AppColors.borderColor, width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Obx(() {
              final selectedIndex = controller.selectedIndex.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: selectedIndex == 0,
                    onTap: () => controller.changeTab(0),
                  ),
                  _NavItem(
                    icon: Icons.show_chart_rounded,
                    activeIcon: Icons.show_chart_rounded,
                    label: 'Signals',
                    isSelected: selectedIndex == 1,
                    onTap: () => controller.changeTab(1),
                  ),
                  _NavItem(
                    icon: Icons.campaign_outlined,
                    activeIcon: Icons.campaign_rounded,
                    label: 'Promo',
                    isSelected: selectedIndex == 2,
                    onTap: () => controller.changeTab(2),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.textSecondary,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: AppStyles.fontSize11(
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
