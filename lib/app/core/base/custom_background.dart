import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomBackground extends StatelessWidget {
  final Widget child;

  const CustomBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.orange,
            Colors.orange,

          ],
          stops: [0.2266, 0.9998, 0.9998],
        ),
      ),
      child: child,
    );
  }
}
/*
Positioned(
bottom: 0,
left: 0,
child: Container(
child: SvgPicture.asset(
AppIcons.magicLine,
//   width: 300,
//   height: 300,
//   fit: BoxFit.contain,
)
),
),*/
