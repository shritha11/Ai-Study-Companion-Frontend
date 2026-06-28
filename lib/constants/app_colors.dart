import 'package:flutter/material.dart';

class AppColors {
  // ===== New Design System =====

  static const background = Color(0xFF09090B);
  static const surface = Color(0xFF18181B);
  static const card = Color(0xFF27272A);

  static const border = Color(0xFF3F3F46);

  static const primary = Color(0xFF7C3AED);
  static const secondary = Color(0xFFA855F7);

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFA1A1AA);
  static const textMuted = Color(0xFF71717A);

  static const glass = Color.fromARGB(25, 255, 255, 255);

  // ===== Compatibility =====
  // (Don't break the existing screens)

  static const bg = background;

  static const primaryDim = Color(0xFF2E1065);

  static const primaryBorder = Color(0xFF8B5CF6);

  static const amber = warning;

  static const blue = Color(0xFF3B82F6);

  static const red = error;

  static const surfaceElevated = Color(0xFF232329);

  static const userBubble = Color(0xFF7C3AED);

  static const userBubbleBorder = Color(0xFFA855F7);
}