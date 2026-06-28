import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/greeting_section.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recent_sessions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            const SliverToBoxAdapter(
              child: GreetingSection(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            const SliverToBoxAdapter(
              child: ContinueLearningCard(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            const SliverToBoxAdapter(
              child: QuickActionGrid(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 28),
            ),

            const SliverToBoxAdapter(
              child: RecentSessions(),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }
}