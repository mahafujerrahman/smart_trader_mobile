import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;

  const TabItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.fontSize14(
          fontWeight: FontWeight.w600,
        ),
        //style: AppTextStyles.textCaption1,
      ),
    );
  }
}
