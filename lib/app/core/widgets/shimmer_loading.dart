import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgTertiary,
      highlightColor: AppColors.bgSurface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.bgTertiary,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}
