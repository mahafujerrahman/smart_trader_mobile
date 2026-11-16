import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primaryColor = Color(0xFF00D4AA);
  static const Color primaryDark = Color(0xFF00A887);
  static const Color primaryLight = Color(0xFF33DDBB);

  // Background Colors
  static const Color bgPrimary = Color(0xFF0A0E1A);
  static const Color bgSecondary = Color(0xFF111827);
  static const Color bgTertiary = Color(0xFF1A2332);
  static const Color bgSurface = Color(0xFF1E2D3D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF475569);

  // Status Colors
  static const Color successColor = Color(0xFF00D4AA);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Border & Divider
  static const Color borderColor = Color(0xFF1E2D3D);
  static const Color dividerColor = Color(0xFF1E293B);

  // Legacy (kept for compatibility)
  static Color blackColor = const Color(0xFF0A0E1A);
  static Color white = const Color(0xFFFFFFFF);
  static Color redColor = const Color(0xFFEF4444);
  static Color greyColor = const Color(0xFF94A3B8);
  static Color hintColor = const Color(0xFF64748B);
  static Color secondaryColor = const Color(0xFF111827);
  static Color color0F9D58 = const Color(0xFF00D4AA);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF00A887)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF111827)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1A2332)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}