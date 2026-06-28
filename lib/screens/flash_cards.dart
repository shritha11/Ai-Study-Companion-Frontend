import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final _controller = TextEditingController();
  List<Flashcard>? _cards;
  int _current = 0;
  bool _loading = false;
  bool _hasText = false;
  String? _activeTopic;

  final _suggestions = ['Linked Lists', 'SQL Joins', 'OS Scheduling', 'OOP Principles', 'Sorting Algorithms'];

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
    super.dispose();
  }

  Future<void> _generate(String topic) async {
    if (topic.trim().isEmpty) return;
    setState(() { _loading = true; _activeTopic = topic.trim(); _cards = null; _current = 0; });
    try {
      final cards = await ApiService.generateFlashcards(topic.trim());
      setState(() { _cards = cards; _loading = false; });
    } catch (_) {
      setState(() { _loading = false; _activeTopic = null; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate flashcards. Try again.')),
        );
      }
    }
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
              color: const Color(0xFF2D2200),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: AppColors.amber.withOpacity(0.3)),
            ),
            child: const Icon(Icons.style_rounded, color: AppColors.amber, size: 16),
          ),
          const SizedBox(width: 10),
          const Text('Flashcards', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ]),
        actions: _cards != null
            ? [
                TextButton.icon(
                  onPressed: () => setState(() { _cards = null; _activeTopic = null; _controller.clear(); }),
                  icon: const Icon(Icons.close_rounded, size: 16, color: AppColors.textSecondary),
                  label: const Text('New topic', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ),
              ]
            : null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: _loading
          ? _loadingView()
          : _cards != null
              ? _cardView()
              : _topicPicker(),
    );
  }

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.amber, strokeWidth: 2.5),
          const SizedBox(height: 16),
          Text('Creating flashcards on "$_activeTopic"...',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        ],
      ),
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
            'Flashcards on\nwhat topic?',
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
            'Type a topic and get flip cards instantly.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  onSubmitted: _generate,
                  decoration: InputDecoration(
                    hintText: 'e.g. Linked Lists, SQL Joins...',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.amber, width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _hasText ? AppColors.amber : AppColors.surface,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _hasText ? AppColors.amber : AppColors.border),
                ),
                child: IconButton(
                  onPressed: _hasText ? () => _generate(_controller.text) : null,
                  icon: Icon(Icons.arrow_forward_rounded,
                      color: _hasText ? Colors.black : AppColors.textMuted, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('SUGGESTIONS', style: TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) => GestureDetector(
              onTap: () => _generate(s),
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
                    const Icon(Icons.style_outlined, color: AppColors.textMuted, size: 14),
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

  Widget _cardView() {
    return Column(
      children: [
        // Counter + topic
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_activeTopic ?? '',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
              Text('${_current + 1} / ${_cards!.length}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ],
          ),
        ),
        // Progress dots
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: List.generate(_cards!.length, (i) => Expanded(
              child: Container(
                height: 3,
                margin: EdgeInsets.only(right: i < _cards!.length - 1 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i <= _current ? AppColors.amber : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )),
          ),
        ),
        // Flip card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _FlipCard(card: _cards![_current]),
          ),
        ),
        // Navigation
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).padding.bottom + 20),
          child: Row(
            children: [
              if (_current > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _current--),
                    icon: const Icon(Icons.arrow_back_rounded, size: 16),
                    label: const Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              if (_current > 0) const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _current < _cards!.length - 1
                      ? () => setState(() => _current++)
                      : () => setState(() { _cards = null; _activeTopic = null; _controller.clear(); }),
                  icon: Icon(_current < _cards!.length - 1 ? Icons.arrow_forward_rounded : Icons.check_rounded, size: 16),
                  label: Text(_current < _cards!.length - 1 ? 'Next' : 'Done'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Flip Card ─────────────────────────────────────────────────────────────

class _FlipCard extends StatefulWidget {
  final Flashcard card;
  const _FlipCard({required this.card});

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _showBack = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card != widget.card) {
      _ctrl.reset();
      _showBack = false;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() {
    if (_showBack) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    setState(() => _showBack = !_showBack);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final angle = _anim.value * pi;
          final isFront = angle < pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isFront ? _face(false) : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(pi),
              child: _face(true),
            ),
          );
        },
      ),
    );
  }

  Widget _face(bool isBack) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isBack ? AppColors.primaryDim : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isBack ? AppColors.primaryBorder.withOpacity(0.4) : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isBack ? AppColors.primary.withOpacity(0.1) : AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isBack ? 'ANSWER' : 'QUESTION',
              style: TextStyle(
                color: isBack ? AppColors.primary : AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              isBack ? widget.card.back : widget.card.front,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isBack ? AppColors.primary : AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.4,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBack ? Icons.lightbulb_rounded : Icons.touch_app_rounded,
                color: isBack ? AppColors.primary : AppColors.textMuted,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                isBack ? 'Tap to see question' : 'Tap to reveal answer',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}