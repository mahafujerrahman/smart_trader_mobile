import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  const CustomListTile({super.key, required this.title});
  @override
  Widget build(BuildContext context) => ListTile(title: Text(title));
}
