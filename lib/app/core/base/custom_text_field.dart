// Legacy file — replaced by AppTextField in app/core/widgets/app_text_field.dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.isPassword = false,
    required,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(controller: controller);
  }
}