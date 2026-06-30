import 'package:flutter/material.dart';

class AppColors {
  // ===== New Design System =====

  static const background = Color(0xFF0F1115); // Very dark neutral
  static const surface = Color(0xFF1A1D22); // Slightly lighter than background
  static const card = Color(0xFF1A1D22); // Same as surface for consistency

  static const border = Color(0xFF2C3038); // Very subtle border

  static const primary = Color(0xFF3B82F6); // Modern Blue accent
  static const secondary = Color(0xFF60A5FA); // Lighter shade of blue for secondary actions

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  static const textPrimary = Colors.white; // High contrast white
  static const textSecondary = Color(0xFFA1A1AA); // Muted gray for secondary text
  static const textMuted = Color(0xFF71717A);

  static const glass = Color.fromARGB(25, 255, 255, 255);

  // ===== Compatibility =====
  // (Don't break the existing screens)

  static const bg = background;

  static const primaryDim = Color(0xFF1E3A8A); // Darker shade of blue

  static const primaryBorder = Color(0xFF60A5FA); // Lighter blue for borders

  static const amber = warning;

  static const blue = primary;

  static const red = error;

  static const surfaceElevated = Color(0xFF2C3038); // Slightly darker than card for elevated elements

  static const userBubble = primary;

  static const userBubbleBorder = secondary;
}



