import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class QuizFlowWidget extends StatefulWidget {
  final String topic;
  final String? documentName;
  final bool standalone; // true = full screen quiz tab, false = embedded in chat

  const QuizFlowWidget({
    super.key,
    required this.topic,
    this.documentName,
    this.standalone = false,
  });

  @override
  State<QuizFlowWidget> createState() => _QuizFlowWidgetState();
}

class _QuizFlowWidgetState extends State<QuizFlowWidget> {
  List<QuizQuestion>? _questions;
  int _current = 0;
  bool _loading = true;
  bool _done = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; _done = false; _current = 0; });
    try {
      final qs = await ApiService.generateQuiz(widget.topic, documentName: widget.documentName);
      setState(() { _questions = qs; _loading = false; });
    } catch (_) {
      setState(() { _error = 'Failed to generate quiz. Try again.'; _loading = false; });
    }
  }

  int get _score => (_questions ?? []).where((q) => q.isCorrect).length;

  @override
  Widget build(BuildContext context) {
    if (_loading) return _loadingCard();
    if (_error != null) return _errorCard();
    if (_done) return _resultCard();
    return _questionCard();
  }

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
          const SizedBox(height: 14),
          Text('Generating quiz on "${widget.topic}"...',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _errorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.red, size: 32),
          const SizedBox(height: 10),
          Text(_error!, textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 14),
          _greenBtn('Retry', _load),
        ],
      ),
    );
  }

  Widget _questionCard() {
    final q = _questions![_current];
    final total = _questions!.length;

    return Container(
      decoration: _cardDecor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDim,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryBorder.withOpacity(0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.quiz_rounded, color: AppColors.primary, size: 12),
                    const SizedBox(width: 5),
                    Text(widget.topic, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                ),
                const Spacer(),
                Text('${_current + 1} / $total',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_current + 1) / total,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 4,
              ),
            ),
          ),
          // Question
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              q.question,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: List.generate(q.options.length, (i) {
                final selected = q.selectedIndex == i;
                final answered = q.isAnswered;
                final isCorrect = i == q.correctIndex;

                Color bg = AppColors.card;
                Color border = AppColors.border;
                Color text = AppColors.textPrimary;
                IconData? trailing;

                if (answered) {
                  if (isCorrect) {
                    bg = AppColors.primaryDim;
                    border = AppColors.primaryBorder;
                    text = AppColors.primary;
                    trailing = Icons.check_circle_rounded;
                  } else if (selected) {
                    bg = const Color(0xFF3A1A1A);
                    border = AppColors.red;
                    text = AppColors.red;
                    trailing = Icons.cancel_rounded;
                  }
                }

                return GestureDetector(
                  onTap: answered ? null : () => setState(() => q.selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border, width: selected || (answered && isCorrect) ? 1.5 : 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(
                            color: answered && isCorrect
                                ? AppColors.primary.withOpacity(0.15)
                                : answered && selected
                                    ? AppColors.red.withOpacity(0.15)
                                    : AppColors.surface,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: border.withOpacity(0.5)),
                          ),
                          child: Center(
                            child: Text(String.fromCharCode(65 + i),
                                style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(q.options[i], style: TextStyle(color: text, fontSize: 14, height: 1.3))),
                        if (trailing != null) ...[
                          const SizedBox(width: 6),
                          Icon(trailing, color: isCorrect ? AppColors.primary : AppColors.red, size: 18),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          // Explanation after answer
          if (q.isAnswered)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2E18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryBorder.withOpacity(0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        q.isCorrect
                            ? 'Correct! Well done.'
                            : 'The correct answer is: ${q.options[q.correctIndex]}',
                        style: const TextStyle(color: AppColors.primary, fontSize: 12, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Navigation
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
            child: Row(
              children: [
                if (_current > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _current--),
                      icon: const Icon(Icons.arrow_back_rounded, size: 15),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                if (_current > 0) const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: q.isAnswered
                        ? () {
                            if (_current < _questions!.length - 1) {
                              setState(() => _current++);
                            } else {
                              setState(() => _done = true);
                            }
                          }
                        : null,
                    icon: Icon(
                      _current < _questions!.length - 1 ? Icons.arrow_forward_rounded : Icons.check_rounded,
                      size: 15,
                    ),
                    label: Text(_current < _questions!.length - 1 ? 'Next' : 'See Results'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.border,
                      disabledForegroundColor: AppColors.textMuted,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultCard() {
    final total = _questions!.length;
    final score = _score;
    final pct = (score / total * 100).round();
    Color c = pct >= 80 ? AppColors.primary : pct >= 50 ? AppColors.amber : AppColors.red;
    String label = pct >= 80 ? 'Excellent!' : pct >= 50 ? 'Good effort!' : 'Keep practicing!';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: c.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: c.withOpacity(0.3), width: 2),
            ),
            child: Icon(
              pct >= 80 ? Icons.emoji_events_rounded : pct >= 50 ? Icons.thumb_up_rounded : Icons.refresh_rounded,
              color: c, size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: c, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('$score out of $total correct',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat('$pct%', 'Score', c),
              Container(width: 1, height: 32, color: AppColors.border),
              _stat('$score', 'Correct', AppColors.primary),
              Container(width: 1, height: 32, color: AppColors.border),
              _stat('${total - score}', 'Wrong', AppColors.red),
            ],
          ),
          const SizedBox(height: 16),
          _greenBtn('Try Again', _load),
        ],
      ),
    );
  }

  Widget _stat(String val, String label, Color color) => Column(
    children: [
      Text(val, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
    ],
  );

  Widget _greenBtn(String label, VoidCallback onTap) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );

  BoxDecoration _cardDecor() => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
  );
}