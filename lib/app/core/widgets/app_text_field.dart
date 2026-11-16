import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';

/// Text field with a password-visibility toggle.
///
/// GetX version: previously a StatefulWidget using `setState` for the
/// obscure toggle — the toggle is now an Rx value rebuilt with [Obx].
/// (The Rx lives with the widget instance, like the old State field did.)
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChanged;

  AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  final RxBool _obscure = true.obs;

  @override
  Widget build(BuildContext context) {
    // NOTE: the obscure Rx must be read UNCONDITIONALLY at the top of the
    // Obx builder. Previously it was only read inside the `isPassword`
    // branches, so for non-password fields Obx saw no observable at all
    // and threw "[Get] the improper use of a GetX has been detected".
    return Obx(() {
      final obscure = _obscure.value;
      return TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword ? obscure : false,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: AppStyles.fontSize15(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.fontSize15(
              color: AppColors.textHint,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () => _obscure.value = !_obscure.value,
                    child: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textHint,
                      size: 20.sp,
                    ),
                  )
                : suffixIcon,
            filled: true,
            fillColor: AppColors.bgTertiary,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide:
                  const BorderSide(color: AppColors.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide:
                  const BorderSide(color: AppColors.errorColor, width: 1.5),
            ),
            errorStyle: AppStyles.fontSize12(color: AppColors.errorColor),
          ),
        );
    });
  }
}
