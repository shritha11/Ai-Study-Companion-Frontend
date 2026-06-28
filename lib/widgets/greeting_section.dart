import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    }

    if (hour < 17) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        18,
        24,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            greeting,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Shritha 👋",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -.8,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Continue your learning journey.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}