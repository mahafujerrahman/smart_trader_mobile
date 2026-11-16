import 'package:flutter/material.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;
  const LoadingWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primaryColor,
        ),
      ),
    );
  }
}
