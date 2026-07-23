import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../utils/learning_helper.dart';
import 'learning_actions.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:audioplayers/audioplayers.dart';

class MessageBubble extends StatefulWidget {
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
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

    @override
  void initState() {
    super.initState();

    _player.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
  }

    @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.message.isUser ? 56 : 16,
        4,
        widget.message.isUser ? 16 : 56,
        4,
      ),
      child: Column(
        crossAxisAlignment:
            widget.message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!widget.message.isUser) _aiHeader(),
          if (!widget.message.isUser) const SizedBox(height: 7),
          widget.message.isVoice ? _voiceBubble() : _bubble(),
          if (!widget.message.isUser) ...[
            const SizedBox(height: 10),
            _actions(context),
            if (widget.message.learningTitle != null) ...[
              const SizedBox(height: 16),
              LearningActions(
                title: widget.message.learningTitle!,
                topic: LearningHelper.extractTopic(widget.message.text),
                documentName: widget.documentName,
                sessionId: widget.sessionId,
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
        color: widget.message.isUser ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(widget.message.isUser ? 18 : 4),
          bottomRight: Radius.circular(widget.message.isUser ? 4 : 18),
        ),
      ),
      child: widget.message.isUser
          ? Text(
              widget.message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.6,
              ),
            )
          : MarkdownBody(
              data: widget.message.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  height: 1.6,
                ),
                h1: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                h2: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                h3: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                strong: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                em: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textPrimary,
                ),
                blockquote: const TextStyle(
                  color: AppColors.textMuted,
                  fontStyle: FontStyle.italic,
                ),
                code: const TextStyle(
                  fontFamily: 'monospace',
                  color: AppColors.primary,
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                listBullet: const TextStyle(
                  color: AppColors.primary,
                ),
                tableBorder: TableBorder.all(
                  color: AppColors.border,
                ),
              ),
            ),
    );

Widget _voiceBubble() {
  return Container(
    width: 230,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: widget.message.isUser
          ? AppColors.primary
          : AppColors.card,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(widget.message.isUser ? 18 : 4),
        bottomRight: Radius.circular(widget.message.isUser ? 4 : 18),
      ),
    ),
    child: Row(
      children: [
        GestureDetector(
  onTap: () async {
    if (widget.message.audioPath == null) return;

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(
        DeviceFileSource(widget.message.audioPath!),
      );
    }
  },
  child: Icon( _isPlaying
    ? Icons.pause_rounded
    : Icons.play_arrow_rounded,
  color: Colors.white,
  size: 28,
  ),
),
        const SizedBox(width: 10),

        Expanded(
  child: LinearProgressIndicator(
    value: _duration.inMilliseconds == 0
        ? 0
        : _position.inMilliseconds / _duration.inMilliseconds,
    minHeight: 3,
    backgroundColor: Colors.white24,
    valueColor: const AlwaysStoppedAnimation(Colors.white),
  ),
),

        const SizedBox(width: 10),

        Text(
  "${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}",
  style: const TextStyle(
    color: Colors.white,
    fontSize: 12,
  ),
)
      ],
    ),
  );
}

  Widget _actions(BuildContext context) => Row(children: [
        _iconBtn(Icons.copy_rounded, () {
          Clipboard.setData(ClipboardData(text: widget.message.text));
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