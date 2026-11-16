import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppStyles {
  static TextStyle _base({
    required double size,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontSize: size.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.textPrimary,
        letterSpacing: letterSpacing,
      );

  static TextStyle fontSize10({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 10, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize11({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 11, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize12({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 12, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize13({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 13, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize14({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 14, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize15({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 15, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize16({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 16, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize17({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 17, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize18({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 18, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize20({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 20, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize22({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 22, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize24({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 24, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize26({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 26, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize28({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 28, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);

  static TextStyle fontSize32({FontWeight fontWeight = FontWeight.normal, Color? color, double? letterSpacing}) =>
      _base(size: 32, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing);
}