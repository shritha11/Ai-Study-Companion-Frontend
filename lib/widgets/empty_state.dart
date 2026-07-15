import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/study_mode.dart';

class EmptyState extends StatelessWidget {
  final void Function(String) onChipTap;
  final StudyMode mode;

  const EmptyState({super.key, required this.onChipTap, this.mode = StudyMode.learn});

  static const _chips = [
    'Data Structures',
    'Flutter',
    'DBMS',
    'Operating Systems',
    'Artificial Intelligence',
    'Computer Networks',
  ];

  @override
  Widget build(BuildContext context) {
      String title;
String subtitle;

switch (mode) {
  case StudyMode.learn:
    title = "What would you like\nto learn today?";
    subtitle =
        "Ask a question, upload notes, or let Lumina create quizzes and flashcards.";
    break;

  case StudyMode.quiz:
    title = "Ready to test\nyour knowledge?";
    subtitle =
        "Enter a topic or upload notes to generate an AI-powered quiz.";
    break;

  case StudyMode.flashcards:
    title = "Let's revise\ntogether!";
    subtitle =
        "Enter a topic or upload notes to create smart flashcards.";
    break;
}

      return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 24),

Text(
  title,
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.4,
  ),
),

const SizedBox(height: 10),

Text(
  subtitle,
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 1.6,
  ),
),

const SizedBox(height: 32),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: _chips
                  .map((chip) => GestureDetector(
                        onTap: () => onChipTap(chip),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            chip,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}