import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;

  const AppIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}