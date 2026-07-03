import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class FlashcardsWidget extends StatefulWidget {
  final String topic;
  final String? documentName;

  const FlashcardsWidget({super.key, required this.topic, this.documentName});

  @override
  State<FlashcardsWidget> createState() => _FlashcardsWidgetState();
}

class _FlashcardsWidgetState extends State<FlashcardsWidget> {
  List<Flashcard>? _cards;
  int _current = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; _current = 0; });
    try {
      final cards = await ApiService.generateFlashcards(widget.topic, documentName: widget.documentName);
      setState(() { _cards = cards; _loading = false; });
    } catch (_) {
      setState(() { _error = 'Failed to generate flashcards.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: _loading
          ? _loadingBody()
          : _error != null
              ? _errorBody()
              : _cardBody(),
    );
  }

  Widget _loadingBody() => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const CircularProgressIndicator(color: AppColors.warning, strokeWidth: 2),
      const SizedBox(height: 14),
      Text('Creating flashcards on "${widget.topic}"...',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
    ]),
  );

  Widget _errorBody() => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 30),
      const SizedBox(height: 10),
      Text(_error!, textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      const SizedBox(height: 14),
      ElevatedButton(
        onPressed: _load,
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.black, elevation: 0),
        child: const Text('Retry'),
      ),
    ]),
  );

  Widget _cardBody() {
    final total = _cards!.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning.withOpacity(0.2)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.style_rounded, color: AppColors.warning, size: 11),
                const SizedBox(width: 5),
                Text(widget.topic,
                    style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ),
            const Spacer(),
            Text('${_current + 1}/$total',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ),
        // Progress strip
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Row(
            children: List.generate(total, (i) => Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: i < total - 1 ? 3 : 0),
                decoration: BoxDecoration(
                  color: i <= _current ? AppColors.warning : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )),
          ),
        ),
        // Flip card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 200,
            child: _FlipCard(card: _cards![_current]),
          ),
        ),
        // Nav
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Row(children: [
            if (_current > 0) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _current--),
                  icon: const Icon(Icons.arrow_back_rounded, size: 14),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _current < total - 1 ? () => setState(() => _current++) : null,
                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                label: Text(_current < total - 1 ? 'Next' : 'Done!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.border,
                  disabledForegroundColor: AppColors.textMuted,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _FlipCard extends StatefulWidget {
  final Flashcard card;
  const _FlipCard({required this.card});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _anim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_FlipCard old) {
    super.didUpdateWidget(old);
    if (old.card != widget.card) { _ctrl.reset(); _flipped = false; }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _flip() {
    _flipped ? _ctrl.reverse() : _ctrl.forward();
    setState(() => _flipped = !_flipped);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _flip,
    child: AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final angle = _anim.value * pi;
        final front = angle < pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(angle),
          child: front
              ? _face(false)
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _face(true),
                ),
        );
      },
    ),
  );

  Widget _face(bool isBack) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: isBack ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isBack ? AppColors.primary.withOpacity(0.3) : AppColors.border,
        width: 1.5,
      ),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isBack ? AppColors.primary.withOpacity(0.1) : AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isBack ? 'ANSWER' : 'QUESTION',
          style: TextStyle(
            color: isBack ? AppColors.primary : AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          isBack ? widget.card.back : widget.card.front,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isBack ? AppColors.primary : AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(isBack ? Icons.lightbulb_rounded : Icons.touch_app_rounded,
            color: AppColors.textMuted, size: 13),
        const SizedBox(width: 5),
        Text(isBack ? 'Tap to see question' : 'Tap to reveal answer',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      ]),
    ]),
  );
}