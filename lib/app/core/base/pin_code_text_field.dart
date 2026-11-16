// Legacy file — pin code fields removed. Use OTP input if needed in future.
import 'package:flutter/material.dart';

class CustomPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final int length;

  const CustomPinCodeTextField({
    super.key,
    this.textEditingController,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: textEditingController);
  }
}
