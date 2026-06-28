import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildFeatureCards(context),
              const SizedBox(height: 28),
              _buildHowItWorks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryDim,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryBorder.withOpacity(0.4)),
              ),
              child: const Icon(Icons.school_rounded, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'StudyAI',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Hi, Shritha 👋',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Where do we\nstart today?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Upload a PDF or just type a topic — the AI handles the rest.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    final cards = [
      _FeatureCard(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Chat & Learn',
        description: 'Ask doubts, get explanations. Upload a PDF and ask questions from it.',
        color: AppColors.blue,
        dim: const Color(0xFF0D1F3C),
        tabIndex: 1,
      ),
      _FeatureCard(
        icon: Icons.quiz_outlined,
        title: 'Generate Quiz',
        description: 'Type a topic or use your PDF — the AI generates MCQs and checks your score.',
        color: AppColors.primary,
        dim: AppColors.primaryDim,
        tabIndex: 2,
      ),
      _FeatureCard(
        icon: Icons.style_outlined,
        title: 'Flashcards',
        description: 'Get flip-card flashcards on any topic or from your uploaded notes.',
        color: AppColors.amber,
        dim: const Color(0xFF2D2200),
        tabIndex: 3,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'WHAT DO YOU WANT TO DO?',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 14),
        ...cards.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  // Switch to the right tab
                  final nav = context.findAncestorStateOfType<_RootNavAccessor>();
                  nav?.switchTab(c.tabIndex);
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: c.dim,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: c.color.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: c.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(c.icon, color: c.color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.title,
                              style: TextStyle(
                                color: c.color,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              c.description,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios_rounded, color: c.color.withOpacity(0.5), size: 14),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {'icon': Icons.upload_file_rounded, 'text': 'Upload a PDF (optional)'},
      {'icon': Icons.chat_rounded, 'text': 'Ask questions or pick a feature'},
      {'icon': Icons.auto_awesome_rounded, 'text': 'AI teaches, quizzes, and creates flashcards'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HOW IT WORKS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          ...steps.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primaryDim,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(e.value['icon'] as IconData, color: AppColors.primary, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      e.value['text'] as String,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _FeatureCard {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color dim;
  final int tabIndex;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.dim,
    required this.tabIndex,
  });
}

// Accessor for tab switching from home cards
mixin _RootNavAccessor on State {
  void switchTab(int index) {}
}