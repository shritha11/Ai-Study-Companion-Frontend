import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        message.isUser ? 64 : 16,
        4,
        message.isUser ? 16 : 64,
        4,
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _buildAIHeader(),
          if (!message.isUser) const SizedBox(height: 6),
          if (!message.isUser) ...[
             const SizedBox(height: 14),
             const Divider(height: 1),
             const SizedBox(height: 12),
             _buildLearningActions(context),
          ],
          if (!message.isUser) _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildLearningActions(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Text(
        "Continue Learning",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),

      const SizedBox(height: 12),

      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [

          _actionChip(
            Icons.quiz_outlined,
            "Quiz Me",
            () {},
          ),

          _actionChip(
            Icons.style_outlined,
            "Flashcards",
            () {},
          ),

          _actionChip(
            Icons.summarize_outlined,
            "Summary",
            () {},
          ),

          _actionChip(
            Icons.lightbulb_outline_rounded,
            "Examples",
            () {},
          ),

          _actionChip(
            Icons.code_rounded,
            "Practice Coding",
            () {},
          ),

        ],
      ),
    ],
  );
}

  Widget _buildAIHeader() {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.smart_toy_rounded,
              color: Colors.white, size: 13),
        ),
        const SizedBox(width: 6),
        const Text(
          'Study AI',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: message.isUser ? AppColors.userBubble : AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(message.isUser ? 18 : 4),
          bottomRight: Radius.circular(message.isUser ? 4 : 18),
        ),
        border: message.isUser
            ? Border.all(color: AppColors.userBubbleBorder.withOpacity(0.4))
            : Border.all(color: AppColors.border),
      ),
      child: Text(
        message.text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          height: 1.55,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Row(
        children: [
          _actionChip(Icons.copy_rounded, 'Copy', () {
            Clipboard.setData(ClipboardData(text: message.text));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied to clipboard'),
                duration: Duration(seconds: 1),
                backgroundColor: AppColors.surface,
              ),
            );
          }),
          const SizedBox(width: 6),
          _actionChip(Icons.thumb_up_outlined, 'Good', () {}),
          const SizedBox(width: 6),
          _actionChip(Icons.quiz_outlined, 'Quiz me', () {}),
        ],
      ),
    );
  }

 Widget _actionChip(
  IconData icon,
  String text,
  VoidCallback onTap,
) {
  return InkWell(
    borderRadius: BorderRadius.circular(24),
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 17,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: 8),

          Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

        ],
      ),
    ),
  );
}
}