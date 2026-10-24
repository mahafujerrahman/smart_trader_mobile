import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.length = 6,
  });

  final TextEditingController? textEditingController;
  final int length;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: textEditingController,
      length: length,
      backgroundColor: Colors.transparent,
      cursorColor: AppColors.primaryColor,
      keyboardType: TextInputType.number,
      obscureText: false,
      autoFocus: false,

      /// 👇 TEXT COLOR
      textStyle: TextStyle(
        color: AppColors.blackColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),

      /// 👇 BORDER STYLE
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),
        fieldHeight: 57.h,
        fieldWidth: 46.w,

        inactiveColor: AppColors.blackColor,
        activeColor: AppColors.blackColor,
        selectedColor: AppColors.blackColor,
      ),

      onChanged: (value) {},
    );
  }
}
