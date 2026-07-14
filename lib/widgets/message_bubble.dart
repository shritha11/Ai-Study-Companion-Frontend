import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../utils/learning_helper.dart';
import 'learning_actions.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final String? documentName;
  final String sessionId;

  const MessageBubble({
    super.key,
    required this.message,
    this.documentName,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        message.isUser ? 56 : 16,
        4,
        message.isUser ? 16 : 56,
        4,
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isUser) _aiHeader(),
          if (!message.isUser) const SizedBox(height: 7),
          _bubble(),
          if (!message.isUser) ...[
            const SizedBox(height: 10),
            _actions(context),
            if (message.learningTitle != null) ...[
              const SizedBox(height: 16),
              LearningActions(
                title: message.learningTitle!,
                topic: LearningHelper.extractTopic(message.text),
                documentName: documentName,
                sessionId: sessionId,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _aiHeader() => Row(children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 13),
        ),
        const SizedBox(width: 7),
        const Text('Lumina',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            )),
      ]);

  Widget _bubble() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isUser ? 18 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 18),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppColors.textPrimary,
            fontSize: 15,
            height: 1.6,
          ),
        ),
      );

  Widget _actions(BuildContext context) => Row(children: [
        _iconBtn(Icons.copy_rounded, () {
          Clipboard.setData(ClipboardData(text: message.text));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Copied'),
            duration: Duration(seconds: 1),
          ));
        }),
        const SizedBox(width: 12),
        _iconBtn(Icons.thumb_up_alt_outlined, () {}),
        const SizedBox(width: 12),
        _iconBtn(Icons.thumb_down_alt_outlined, () {}),
      ]);

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: AppColors.textMuted, size: 17),
      );
}