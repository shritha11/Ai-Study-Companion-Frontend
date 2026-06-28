import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header()),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(child: _continueLearning()),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(child: _quickActions(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 28)),
            SliverToBoxAdapter(child: _recentSessions()),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_greeting,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15)),
          const SizedBox(height: 4),
          const Text('Shritha 👋',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
              )),
          const SizedBox(height: 10),
          const Text('Continue your learning journey.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _continueLearning() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Continue Learning',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 14),
              const Text('Data Structures',
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Last session · Today · 6:42 PM',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 20),
              Row(children: [
                const Text('Resume Learning',
                    style: TextStyle(
                        color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Start Learning',
              style: TextStyle(
                  color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text("Choose how you'd like to continue.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 18),
          _largeAction(
            icon: Icons.auto_awesome_rounded,
            title: 'Learn',
            subtitle: 'Ask Lumina anything',
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _smallAction(
                icon: Icons.quiz_outlined,
                title: 'Practice',
                subtitle: 'AI Quiz',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _smallAction(
                icon: Icons.style_outlined,
                title: 'Revise',
                subtitle: 'Flashcards',
                color: AppColors.warning,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          _largeAction(
            icon: Icons.folder_open_rounded,
            title: 'Library',
            subtitle: 'Your PDFs & Notes',
            color: AppColors.blue,
          ),
        ],
      ),
    );
  }

  Widget _largeAction({required IconData icon, required String title, required String subtitle, required Color color}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ]),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 15),
        ]),
      ),
    );
  }

  Widget _smallAction({required IconData icon, required String title, required String subtitle, required Color color}) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(subtitle,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ]),
      ),
    );
  }

  Widget _recentSessions() {
    final sessions = [
      {'title': 'Binary Search', 'time': 'Today · 6:42 PM', 'icon': Icons.search_rounded},
      {'title': 'Operating Systems', 'time': 'Yesterday', 'icon': Icons.memory_rounded},
      {'title': 'Flutter Widgets', 'time': '2 days ago', 'icon': Icons.widgets_outlined},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Sessions',
              style: TextStyle(
                  color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Continue from where you left off.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 18),
          ...sessions.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(s['icon'] as IconData, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s['title'] as String,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      Text(s['time'] as String,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ]),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 14),
                ]),
              ),
            ),
          )),
        ],
      ),
    );
  }
}