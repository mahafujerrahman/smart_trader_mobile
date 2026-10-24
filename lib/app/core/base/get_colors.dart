import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:flutter/material.dart';

class GetStatusColors {
  // Get Colors
  static Color customColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.grey;
      case 'In Progress':
        return Colors.green;
      case 'Not Started':
        return Colors.blueGrey;
      case 'Resolved':
        return Colors.blue;
      case 'Completed':
        return Colors.blue;
      case 'Closed':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.black54;
    }
  }
}
