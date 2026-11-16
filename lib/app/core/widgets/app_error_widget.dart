import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: AppColors.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(40.r),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: AppColors.errorColor,
                size: 36.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Oops!',
              style: AppStyles.fontSize20(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.fontSize14(color: AppColors.textSecondary),
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Try Again',
                    style: AppStyles.fontSize14(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
