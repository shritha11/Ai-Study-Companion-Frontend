import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final bool isListening;
  final bool hasPdf;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.isListening,
    this.hasPdf = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      final h = widget.controller.text.trim().isNotEmpty;
      if (h != _hasText) setState(() => _hasText = h);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onAttach,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: Icon(
              Icons.attach_file_rounded,
              color: widget.hasPdf ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
          ),
          Expanded(
            child: TextField(
              controller: widget.controller,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.card,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
              onSubmitted: (_) => widget.onSend(),
              textInputAction: TextInputAction.newline,
            ),
          ),
          const SizedBox(width: 8),
          Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    color: widget.isListening
        ? Colors.red
        : AppColors.card,
    borderRadius: BorderRadius.circular(13),
    border: Border.all(
      color: widget.isListening
          ? Colors.red
          : AppColors.border,
    ),
  ),
  child: GestureDetector(
  onLongPressStart: (_) => widget.onStartRecording(),
  onLongPressEnd: (_) => widget.onStopRecording(),
  child: Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: widget.isListening
          ? Colors.red
          : AppColors.card,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(
        color: widget.isListening
            ? Colors.red
            : AppColors.border,
      ),
    ),
    child: Icon(
      widget.isListening
          ? Icons.mic
          : Icons.mic_none,
      color: widget.isListening
          ? Colors.white
          : AppColors.textMuted,
    ),
  ),
),
),
const SizedBox(width: 8),
Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    color: widget.isListening
        ? Colors.red
        : AppColors.card,
    borderRadius: BorderRadius.circular(13),
    border: Border.all(
      color: widget.isListening
          ? Colors.red
          : AppColors.border,
    ),
  ),
),

const SizedBox(width: 8),

AnimatedContainer(
  duration: const Duration(milliseconds: 180),
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    color: _hasText
        ? AppColors.primary
        : AppColors.card,
    borderRadius: BorderRadius.circular(13),
    border: Border.all(
      color: _hasText
          ? AppColors.primary
          : AppColors.border,
    ),
  ),
  child: IconButton(
    padding: EdgeInsets.zero,
    onPressed: _hasText ? widget.onSend : null,
    icon: Icon(
      Icons.arrow_upward_rounded,
      color: _hasText
          ? Colors.white
          : AppColors.textMuted,
      size: 18,
    ),
  ),
),
        ],
      ),
    );
  }
}