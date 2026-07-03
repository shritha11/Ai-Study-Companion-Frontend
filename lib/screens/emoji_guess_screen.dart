import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

import '../models/emoji_item.dart';
import '../services/emoji_guess_service.dart';

class EmojiGuessScreen extends StatefulWidget {
  const EmojiGuessScreen({super.key});

  @override
  State<EmojiGuessScreen> createState() => _EmojiGuessScreenState();
}

class _EmojiGuessScreenState extends State<EmojiGuessScreen> {
  bool _loading = true;
  bool _isGameOver = false;
  int _current = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;

  late List<EmojiItem> _items;
  List<String> _options = [];

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    try {
      // 1. Fetch the random file pool from the service (Movies, Brands, Countries, or Games)
      final fetchedItems = await EmojiGuessService.loadRandomGame();
      if (!mounted) return;

      setState(() {
        _items = fetchedItems;
        _current = 0;
        _score = 0;
        _selectedIndex = null;
        _answered = false;
        _isGameOver = false;
        
        // 2. FORCE the options generator to only use the newly selected JSON items pool
        if (_items.isNotEmpty) {
          _options = _generateOptions(_items[_current], _items);
        }
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  // Explicitly passing the current active pool ensures wrong options match the active category
  List<String> _generateOptions(EmojiItem currentItem, List<EmojiItem> activePool) {
    final answers = activePool
        .map((e) => e.answer)
        .where((e) => e != currentItem.answer)
        .toList();

    answers.shuffle();

    final options = [
      currentItem.answer,
      ...answers.take(3),
    ];

    options.shuffle();
    return options;
  }

  void _handleSubmission() {
    if (_selectedIndex == null) return;

    setState(() {
      _answered = true;
      if (_options[_selectedIndex!] == _items[_current].answer) {
        _score++;
      }
    });
  }

  void _next() {
    if (_current == _items.length - 1) {
      setState(() {
        _isGameOver = true;
      });
      return;
    }

    setState(() {
      _current++;
      _answered = false;
      _selectedIndex = null;
      // Regenerate using the explicit pool bounds
      _options = _generateOptions(_items[_current], _items);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isGameOver) {
      return _buildGameOverView();
    }

    final item = _items[_current];
    final isCorrectSelection = _answered && (_options[_selectedIndex ?? 0] == item.answer);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Emoji Guess",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Puzzle ${_current + 1} / ${_items.length}",
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Text("🏆 ", style: TextStyle(fontSize: 16)),
                        Text(
                          "$_score",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.small),
                child: LinearProgressIndicator(
                  value: (_current + 1) / _items.length,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppRadius.large),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Text(
                            item.emoji,
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      ...List.generate(
                        _options.length,
                        (index) {
                          final option = _options[index];
                          Color border = AppColors.border;
                          Color bg = AppColors.card;
                          Color textColor = AppColors.textPrimary;

                          if (_answered) {
                            if (option == item.answer) {
                              bg = Colors.green.withOpacity(.12);
                              border = Colors.green;
                              textColor = Colors.green.shade800;
                            } else if (index == _selectedIndex) {
                              bg = Colors.red.withOpacity(.12);
                              border = Colors.red;
                              textColor = Colors.red.shade800;
                            }
                          } else if (_selectedIndex == index) {
                            bg = AppColors.primary.withOpacity(.10);
                            border = AppColors.primary;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: GestureDetector(
                              onTap: _answered
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                    },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: border, width: 2),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    if (_answered && option == item.answer)
                                      const Icon(Icons.check_circle_rounded, color: Colors.green)
                                    else if (_answered && index == _selectedIndex)
                                      const Icon(Icons.cancel_rounded, color: Colors.red),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _answered
                    ? Container(
                        key: ValueKey<int>(_current),
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isCorrectSelection ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                        ),
                        child: Row(
                          children: [
                            Text(isCorrectSelection ? "🎉" : "❌", style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 12),
                            Text(
                              isCorrectSelection ? "Correct!" : "Nice try!",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: isCorrectSelection ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedIndex == null ? Colors.grey.shade400 : AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: _selectedIndex == null
                      ? null
                      : (_answered ? _next : _handleSubmission),
                  child: Text(
                    _answered ? "Next →" : "Submit Answer",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverView() {
    final double standardPercent = _items.isEmpty ? 0 : (_score / _items.length);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(
                child: Text("🏁", style: TextStyle(fontSize: 80)),
              ),
              const SizedBox(height: 24),
              Text(
                "Challenge Complete!",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                standardPercent >= 0.6 
                    ? "Fantastic job keeping your brain active!"
                    : "Great practice! Try again to boost your score.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "SCORE",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "🏆 $_score",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 40, color: AppColors.border),
                    Column(
                      children: [
                        Text(
                          "ACCURACY",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${(standardPercent * 100).toInt()}%",
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _loading = true;
                    });
                    _loadGame();
                  },
                  child: Text(
                    "Play Again",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.border, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back Home",
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}