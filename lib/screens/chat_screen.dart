import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';
import '../widgets/quiz_flow.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<_ChatItem> _items = [];
  bool _loading = false;
  bool _hasText = false;
  String? _pdfContext;
  String? _pdfName;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final h = _controller.text.trim().isNotEmpty;
      if (h != _hasText) setState(() => _hasText = h);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _isQuizRequest(String text) {
    final lower = text.toLowerCase();
    return lower.contains('quiz') ||
        lower.contains('test me') ||
        lower.contains('mcq') ||
        lower.contains('question');
  }

  String _extractTopic(String text) {
    final lower = text.toLowerCase();
    for (final kw in ['quiz on', 'quiz about', 'test me on', 'mcq on', 'questions on', 'questions about']) {
      if (lower.contains(kw)) {
        final idx = lower.indexOf(kw) + kw.length;
        return text.substring(idx).trim();
      }
    }
    return text.replaceAll(RegExp(r'(?i)generate|quiz|test me|mcq|questions?'), '').trim();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    final msg = text.trim();
    _controller.clear();

    setState(() {
      _items.add(_ChatItem.message(MessageModel(text: msg, isUser: true)));
      _loading = true;
    });
    _scrollDown();

    // Detect quiz intent
    if (_isQuizRequest(msg)) {
      final topic = _extractTopic(msg).isNotEmpty ? _extractTopic(msg) : 'General Knowledge';
      setState(() {
        _loading = false;
        _items.add(_ChatItem.aiMessage('Sure! Generating a quiz on **$topic**...'));
        _items.add(_ChatItem.quiz(topic, _pdfContext));
      });
      _scrollDown();
      return;
    }

    try {
      final reply = await ApiService.chat(msg, pdfContext: _pdfContext);
      setState(() {
        _loading = false;
        _items.add(_ChatItem.message(MessageModel(text: reply, isUser: false)));
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _items.add(_ChatItem.message(
            MessageModel(text: 'Something went wrong. Please try again.', isUser: false)));
      });
    }
    _scrollDown();
  }

  void _simulatePdfUpload() {
    // Simulated — replace with file_picker in real app
    setState(() {
      _pdfName = 'DSA_Notes.pdf';
      _pdfContext = 'This document covers Data Structures and Algorithms including Arrays, Linked Lists, Trees, Graphs, Sorting and Searching algorithms.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Text('$_pdfName uploaded — AI will use this context'),
        ]),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_pdfName != null) _pdfBanner(),
          Expanded(
            child: _items.isEmpty ? _emptyState() : _buildList(),
          ),
          if (_loading) _typingIndicator(),
          _inputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryDim,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.primaryBorder.withOpacity(0.3)),
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 10),
          const Text('Chat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _pdfBanner() {
    return Container(
      color: AppColors.primaryDim,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$_pdfName — AI will answer from this PDF',
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() { _pdfName = null; _pdfContext = null; }),
            child: const Icon(Icons.close_rounded, color: AppColors.primary, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    final suggestions = [
      'Explain Binary Trees',
      'Generate a quiz on Arrays',
      'What is dynamic programming?',
      'Difference between stack and queue',
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryDim,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primaryBorder.withOpacity(0.3)),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ask anything',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3),
            ),
            const SizedBox(height: 6),
            const Text(
              'Or say "generate a quiz on X" to start a quiz right here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions.map((s) => GestureDetector(
                onTap: () => _send(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(s, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _items.length,
      itemBuilder: (_, i) {
        final item = _items[i];
        if (item.type == _ChatItemType.quiz) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: QuizFlowWidget(topic: item.quizTopic!, pdfContext: item.pdfContext),
          );
        }
        return _Bubble(msg: item.message!);
      },
    );
  }

  Widget _typingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 64, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16),
            bottomRight: Radius.circular(16), bottomLeft: Radius.circular(4),
          ),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16, height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
            SizedBox(width: 10),
            Text('Thinking...', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        left: 12, right: 12, top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _simulatePdfUpload,
            icon: Icon(
              Icons.attach_file_rounded,
              color: _pdfName != null ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            tooltip: 'Upload PDF',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Ask anything...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
              ),
              onSubmitted: (_) => _send(_controller.text),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _hasText ? AppColors.primary : AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _hasText ? AppColors.primary : AppColors.border),
            ),
            child: IconButton(
              onPressed: _hasText ? () => _send(_controller.text) : null,
              icon: Icon(Icons.arrow_upward_rounded,
                  color: _hasText ? Colors.white : AppColors.textMuted, size: 18),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat item types ────────────────────────────────────────────────────────

enum _ChatItemType { message, quiz }

class _ChatItem {
  final _ChatItemType type;
  final MessageModel? message;
  final String? quizTopic;
  final String? pdfContext;

  _ChatItem._({required this.type, this.message, this.quizTopic, this.pdfContext});

  factory _ChatItem.message(MessageModel m) => _ChatItem._(type: _ChatItemType.message, message: m);
  factory _ChatItem.aiMessage(String text) =>
      _ChatItem._(type: _ChatItemType.message, message: MessageModel(text: text, isUser: false));
  factory _ChatItem.quiz(String topic, String? ctx) =>
      _ChatItem._(type: _ChatItemType.quiz, quizTopic: topic, pdfContext: ctx);
}

// ── Bubble ─────────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  final MessageModel msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(msg.isUser ? 56 : 16, 4, msg.isUser ? 16 : 56, 4),
      child: Column(
        crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!msg.isUser)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(children: [
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDim,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primaryBorder.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 11),
                ),
                const SizedBox(width: 6),
                const Text('Study AI', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: msg.isUser ? AppColors.primaryDim : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                bottomRight: Radius.circular(msg.isUser ? 4 : 16),
              ),
              border: Border.all(
                color: msg.isUser ? AppColors.primaryBorder.withOpacity(0.3) : AppColors.border,
              ),
            ),
            child: Text(msg.text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, height: 1.55)),
          ),
          if (!msg.isUser)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(children: [
                _chip(Icons.copy_rounded, 'Copy', () => Clipboard.setData(ClipboardData(text: msg.text))),
                const SizedBox(width: 6),
                _chip(Icons.thumb_up_outlined, 'Helpful', () {}),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: AppColors.textMuted, size: 12),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}