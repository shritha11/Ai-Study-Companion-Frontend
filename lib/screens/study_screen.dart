import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../models/study_item.dart';
import '../services/api_service.dart';
import '../utils/learning_helper.dart';
import '../widgets/chat_input.dart';
import '../widgets/empty_state.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/quiz_widget.dart';
import '../widgets/flashcards_widget.dart';
import '../widgets/summary_widget.dart';
//import '../widgets/examples_widget.dart';
//import '../widgets/coding_widget.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final List<StudyItem> _timeline = [];
  bool _isTyping = false;
  String? _pdfContext;
  String? _pdfName;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    final msg = text.trim();
    if (msg.isEmpty) return;
    _controller.clear();

    setState(() {
      _timeline.add(StudyItem.message(MessageModel(text: msg, isUser: true)));
      _isTyping = true;
    });
    _scrollBottom();

    try {
      final response = await ApiService.chat(msg, pdfContext: _pdfContext);
      final title = LearningHelper.getTitle(msg);
      setState(() {
        _timeline.add(StudyItem.message(MessageModel(
          text: response,
          isUser: false,
          learningTitle: title,
        )));
        _isTyping = false;
      });
    } catch (_) {
      setState(() {
        _timeline.add(StudyItem.message(MessageModel(
          text: 'Something went wrong. Please try again.',
          isUser: false,
        )));
        _isTyping = false;
      });
    }
    _scrollBottom();
  }

  void _addWidget(StudyItem item) {
    setState(() => _timeline.add(item));
    _scrollBottom();
  }

  void _uploadPdf() {
    setState(() {
      _pdfName = 'DSA_Notes.pdf';
      _pdfContext =
          'This document covers Data Structures and Algorithms including Arrays, Linked Lists, Trees, Graphs, Sorting and Searching algorithms.';
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text('$_pdfName uploaded'),
      ]),
      backgroundColor: AppColors.card,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_pdfName != null) _pdfBanner(),
          Expanded(
            child: _timeline.isEmpty
                ? EmptyState(onChipTap: _send)
                : _buildTimeline(),
          ),
          if (_isTyping) const TypingIndicator(),
          ChatInput(
            controller: _controller,
            onSend: () => _send(_controller.text),
            onAttach: _uploadPdf,
            hasPdf: _pdfName != null,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.background,
      title: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        const Text('Lumina',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ]),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.border),
      ),
    );
  }

  Widget _pdfBanner() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text('$_pdfName · AI will answer from this PDF',
              style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        GestureDetector(
          onTap: () => setState(() { _pdfName = null; _pdfContext = null; }),
          child: const Icon(Icons.close_rounded, color: AppColors.primary, size: 16),
        ),
      ]),
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: _timeline.length,
      itemBuilder: (_, i) {
        final item = _timeline[i];
        return _TimelineItemWrapper(
          key: ValueKey(i),
          child: _buildItem(item),
        );
      },
    );
  }

  Widget _buildItem(StudyItem item) {
    switch (item.type) {
      case StudyItemType.message:
        return MessageBubble(
          message: item.message!,
          onQuiz: () => _addWidget(StudyItem.quiz(
              topic: LearningHelper.extractTopic(item.message!.text),
              pdfContext: _pdfContext)),
          onFlashcards: () => _addWidget(StudyItem.flashcards(
              topic: LearningHelper.extractTopic(item.message!.text),
              pdfContext: _pdfContext)),
          onSummary: () => _addWidget(StudyItem.summary(
              topic: LearningHelper.extractTopic(item.message!.text))),
          onExamples: () => _addWidget(StudyItem.examples(
              topic: LearningHelper.extractTopic(item.message!.text))),
          onCoding: () => _addWidget(StudyItem.coding(
              topic: LearningHelper.extractTopic(item.message!.text))),
        );
      case StudyItemType.quiz:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: QuizWidget(topic: item.topic!, pdfContext: item.pdfContext),
        );
      case StudyItemType.flashcards:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FlashcardsWidget(topic: item.topic!, pdfContext: item.pdfContext),
        );
      case StudyItemType.summary:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SummaryWidget(topic: item.topic!),
        );
      case StudyItemType.examples:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ExamplesWidget(topic: item.topic!),
        );
      case StudyItemType.coding:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CodingWidget(topic: item.topic!),
        );
    }
  }
}

class _TimelineItemWrapper extends StatefulWidget {
  final Widget child;
  const _TimelineItemWrapper({super.key, required this.child});

  @override
  State<_TimelineItemWrapper> createState() => _TimelineItemWrapperState();
}

class _TimelineItemWrapperState extends State<_TimelineItemWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}