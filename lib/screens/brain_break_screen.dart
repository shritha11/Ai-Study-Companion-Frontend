import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'brain_break_quiz_screen.dart';
import 'emoji_guess_screen.dart';
import 'would_you_rather_screen.dart';

import '../models/brain_break_challenge.dart';
import '../services/brain_break_service.dart';

class BrainBreakScreen extends StatefulWidget {
  const BrainBreakScreen({super.key});

  @override
  State<BrainBreakScreen> createState() => _BrainBreakScreenState();
}

class _BrainBreakScreenState extends State<BrainBreakScreen> {
  BrainBreakChallenge? challenge;
  bool _loading = true;
  late String gameType;

  @override
  void initState() {
    super.initState();
    _loadChallenge();
  }

  Future<void> _loadChallenge() async {
    try {
      challenge = await BrainBreakService.loadRandomChallenge();
      
      final games = ["quiz", "emoji", "wyr"];
      gameType = games[Random().nextInt(games.length)];
    } catch (e) {
      // Safe fallback logic if service infrastructure returns null configuration
      gameType = Random().nextBool() ? "quiz" : "emoji";
    }

    if (!mounted) return;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Text(
          "Brain Break",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _loading ? _loadingView() : _challengeView(),
      ),
    );
  }

  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween(begin: 0.8, end: 1.2),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (_, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: const Text(
              "🎲",
              style: TextStyle(fontSize: 70),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Preparing today's challenge...",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _challengeView() {
    final isQuiz = gameType == "quiz";

    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  gameType == "quiz"
      ? Icons.psychology_alt_rounded
      : gameType == "emoji"
          ? Icons.emoji_emotions_rounded
          : Icons.balance_rounded,
                  size: 46,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                gameType == "quiz"
                    ? "Today's Quiz"
                    : gameType == "emoji"
                        ? "Today's Emoji Guess"
                        : "Today's Would You Rather",
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                challenge?.title ?? "Quick Mental Refresher",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Estimated Time • ${challenge?.estimatedTime ?? '3 mins'}",
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () {
  if (gameType == "quiz") {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BrainBreakQuizScreen(challenge: challenge!)));
  } else if (gameType == "emoji") {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const EmojiGuessScreen()));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WouldYouRatherScreen()));
  }
},
                  child: Text(
                    "Start Challenge",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}