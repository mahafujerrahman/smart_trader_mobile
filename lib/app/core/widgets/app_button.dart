import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Widget? leadingIcon;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.leadingIcon,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height ?? 54.h,
        decoration: BoxDecoration(
          gradient: (backgroundColor == null)
              ? AppColors.primaryGradient
              : null,
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leadingIcon != null) ...[leadingIcon!, SizedBox(width: 8.w)],
                    Text(
                      text,
                      style: AppStyles.fontSize16(
                        fontWeight: FontWeight.bold,
                        color: textColor ?? Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
