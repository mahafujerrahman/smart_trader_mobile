import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/routes/routes.dart';

class AdminBottomMenu extends StatelessWidget {
  final int menuIndex;
  const AdminBottomMenu(this.menuIndex, {super.key});

  void onTap(int index) {
    switch (index) {
      case 0:
        Get.offAndToNamed(AppRoutes.logInScreen);
        break;
      case 1:
        Get.offAndToNamed(AppRoutes.logInScreen);
        break;
      case 2:
        Get.offAndToNamed(AppRoutes.logInScreen);
        break;
    }
  }

  Widget getItem(String icon, String title, int index) {
    final isSelected = index == menuIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          border: isSelected ? Border(bottom: BorderSide(color: AppColors.white, width: 3.w)) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(icon, height: 24.h, width: 24.w, color: AppColors.blackColor),
              if (isSelected) Text(title, style: TextStyle(color: AppColors.blackColor, fontSize: 12.sp)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppColors.colorA4FFA4,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            getItem(menuIndex == 0 ? AppIcons.homeFillupIcon : AppIcons.homeIcon, 'Home', 0),
            getItem(menuIndex == 1 ? AppIcons.myTeamIconFillUp : AppIcons.myTeamIcon, 'My Team', 1),
            getItem(menuIndex == 2 ? AppIcons.settingsFillup : AppIcons.settingsIcon, 'Settings', 2),
          ],
        ),
      ),
    );
  }
}
