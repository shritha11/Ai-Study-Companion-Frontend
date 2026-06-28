import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LuminaBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const LuminaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 14,
      ),
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            _item(
              index: 0,
              icon: Icons.home_rounded,
              label: "Home",
            ),

            _item(
              index: 1,
              icon: Icons.auto_awesome_rounded,
              label: "Learn",
            ),

            _item(
              index: 2,
              icon: Icons.folder_open_rounded,
              label: "Library",
            ),

            _item(
              index: 3,
              icon: Icons.person_outline_rounded,
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required int index,
    required IconData icon,
    required String label,
  }) {

    final selected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 16 : 0,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withOpacity(.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [

            Icon(
              icon,
              size: 22,
              color: selected
                  ? Colors.white
                  : AppColors.textSecondary,
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        key: ValueKey(label),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ),
      ),
    );
  }
}