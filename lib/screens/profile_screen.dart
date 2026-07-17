import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
//import '../models/user_model.dart';
import '../services/api_service.dart';
import '../models/dashboard_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DashboardModel? dashboard;
  bool isLoading = true;

  final settings = [
    {
      'icon': Icons.person_outline_rounded,
      'label': 'Account',
      'color': AppColors.primary,
    },
    {
      'icon': Icons.notifications_outlined,
      'label': 'Notifications',
      'color': AppColors.warning,
    },
    {
      'icon': Icons.palette_outlined,
      'label': 'Appearance',
      'color': AppColors.blue,
    },
    {
      'icon': Icons.lock_outline_rounded,
      'label': 'Privacy',
      'color': AppColors.success,
    },
    {
      'icon': Icons.help_outline_rounded,
      'label': 'Help & Support',
      'color': AppColors.textSecondary,
    },
    {
      'icon': Icons.logout_rounded,
      'label': 'Logout',
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      dashboard = await ApiService.getDashboard();
      print(dashboard!.user.name);
      print(dashboard!.user.email);

    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (dashboard == null) {
  return const Scaffold(
    body: Center(
      child: Text("Failed to load profile"),
    ),
  );
}


    final stats = [
  {
    "label": "Streak",
    "value": dashboard!.user.currentStreak.toString(),
  },
  {
    "label": "Quizzes",
    "value": dashboard!.stats.quizzes.toString(),
  },
  {
    "label": "Flashcards",
    "value": dashboard!.stats.flashcards.toString(),
  },
];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          dashboard!.user.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      dashboard!.user.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dashboard!.user.email,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: stats
                            .map(
                              (s) => Column(
                                children: [
                                  Text(
                                    s['value']!,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s['label']!,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "SETTINGS",
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final s = settings[i];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                    child: InkWell(
                      onTap: () async {
                        if ((s['label'] as String) == "Logout") {
                          await context.read<AuthProvider>().logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: (s['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                s['icon'] as IconData,
                                color: s['color'] as Color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                s['label'] as String,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.textMuted,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: settings.length,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 40),
            ),
          ],
        ),
      ),
    );
  }
}