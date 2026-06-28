import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,

    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.background,

    textTheme: GoogleFonts.plusJakartaSansTextTheme(),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,

      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),

      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
  );
}