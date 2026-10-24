import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87, width: 3),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: value
            ? Center(
          child: Icon(
            Icons.done,
            size: 12.sp,
            color: Colors.black,
          ),
        )
            : null,
      ),
    );
  }
}
