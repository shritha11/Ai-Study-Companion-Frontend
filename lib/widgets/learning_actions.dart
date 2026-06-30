import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'learning_sheet.dart';
import 'quiz_widget.dart';
import 'flashcards_widget.dart';
import 'summary_widget.dart';

class LearningActions extends StatelessWidget {
  final String title;
  final String topic;
  final String? pdfContext;

  const LearningActions({
    super.key,
    required this.title,
    required this.topic,
    this.pdfContext,
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
            _chip(context, Icons.quiz_outlined, 'Quiz Me', AppColors.primary, () {
              showLearningSheet(
                context: context,
                title: 'Quiz · $topic',
                icon: Icons.quiz_outlined,
                accentColor: AppColors.primary,
                child: QuizWidget(topic: topic, pdfContext: pdfContext),
              );
            }),
            _chip(context, Icons.style_outlined, 'Flashcards', AppColors.warning, () {
              showLearningSheet(
                context: context,
                title: 'Flashcards · $topic',
                icon: Icons.style_outlined,
                accentColor: AppColors.warning,
                child: FlashcardsWidget(topic: topic, pdfContext: pdfContext),
              );
            }),
            _chip(context, Icons.summarize_outlined, 'Summary', AppColors.blue, () {
              showLearningSheet(
                context: context,
                title: 'Summary · $topic',
                icon: Icons.summarize_outlined,
                accentColor: AppColors.blue,
                child: SummaryWidget(topic: topic),
              );
            }),
            _chip(context, Icons.lightbulb_outline_rounded, 'Examples', AppColors.success, () {
              showLearningSheet(
                context: context,
                title: 'Examples · $topic',
                icon: Icons.lightbulb_outline_rounded,
                accentColor: AppColors.success,
                child: ExamplesWidget(topic: topic),
              );
            }),
            _chip(context, Icons.code_rounded, 'Practice Coding', AppColors.primary, () {
              showLearningSheet(
                context: context,
                title: 'Coding · $topic',
                icon: Icons.code_rounded,
                accentColor: AppColors.primary,
                child: CodingWidget(topic: topic),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
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
            Icon(icon, size: 14, color: color),
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