import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_icons.dart'; // Adjust path if needed

class CustomMagicLineBackground extends StatelessWidget {
  final Widget child;

  const CustomMagicLineBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [
          // 🔳 White background
          Container(
            color: Colors.white,
          ),
          // 🔻 Magic line positioned at bottom-left
          Positioned(
            bottom: 0,
            left: 0,
            child: IgnorePointer(
              child: SvgPicture.asset(
                AppIcons.magicLine,
                height: 265,
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 🔼 Foreground content
          child,
        ],
      ),
    );
  }
}
