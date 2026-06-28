import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/quiz_flow.dart';

class QuizScreen extends StatefulWidget {
  final String? initialTopic;

  const QuizScreen({super.key, this.initialTopic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _controller = TextEditingController();
  String? _activeTopic;
  bool _hasText = false;

  final _suggestions = [
    'Data Structures',
    'Operating Systems',
    'Computer Networks',
    'DBMS',
    'OOP Concepts',
    'Algorithms',
  ];

  @override
  void initState() {
    super.initState();
    if(widget.initialTopic != null){
    _controller.text = widget.initialTopic!;
    _startQuiz(widget.initialTopic!);

  }
    _controller.addListener(() {
      final h = _controller.text.trim().isNotEmpty;
      if (h != _hasText) setState(() => _hasText = h);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startQuiz(String topic) {
    if (topic.trim().isEmpty) return;
    setState(() => _activeTopic = topic.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryDim,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.primaryBorder.withOpacity(0.3)),
            ),
            child: const Icon(Icons.quiz_rounded, color: AppColors.primary, size: 16),
          ),
          const SizedBox(width: 10),
          const Text('Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ]),
        actions: _activeTopic != null
            ? [
                TextButton.icon(
                  onPressed: () => setState(() { _activeTopic = null; _controller.clear(); }),
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textSecondary),
                  label: const Text('New quiz', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ),
              ]
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: _activeTopic != null ? _quizView() : _topicPicker(),
    );
  }

  Widget _topicPicker() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            'What do you want\nto be quizzed on?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Type a topic or pick a suggestion.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          // Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  onSubmitted: _startQuiz,
                  decoration: InputDecoration(
                    hintText: 'e.g. Binary Trees, DBMS...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _hasText ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _hasText ? AppColors.primary : AppColors.border),
                ),
                child: IconButton(
                  onPressed: _hasText ? () => _startQuiz(_controller.text) : null,
                  icon: Icon(Icons.arrow_forward_rounded,
                      color: _hasText ? Colors.white : AppColors.textMuted, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'POPULAR TOPICS',
            style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) => GestureDetector(
              onTap: () => _startQuiz(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.quiz_outlined, color: AppColors.textMuted, size: 14),
                    const SizedBox(width: 6),
                    Text(s, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _quizView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: QuizFlowWidget(topic: _activeTopic!, standalone: true),
    );
  }
}