import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class LearningActions extends StatelessWidget {
  final String title;
  final VoidCallback onQuiz;
  final VoidCallback onFlashcards;
  final VoidCallback onSummary;
  final VoidCallback onExamples;
  final VoidCallback onCoding;

  const LearningActions({
    super.key,
    required this.title,
    required this.onQuiz,
    required this.onFlashcards,
    required this.onSummary,
    required this.onExamples,
    required this.onCoding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _chip(Icons.quiz_outlined, 'Quiz Me', onQuiz),
            _chip(Icons.style_outlined, 'Flashcards', onFlashcards),
            _chip(Icons.summarize_outlined, 'Summary', onSummary),
            _chip(Icons.lightbulb_outline_rounded, 'Examples', onExamples),
            _chip(Icons.code_rounded, 'Practice Coding', onCoding),
          ],
        ),
      ],
    );
  }

  Widget _chip(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}