import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import 'brain_break_quiz_screen.dart';

class BrainBreakScreen extends StatefulWidget {
  const BrainBreakScreen({super.key});

  @override
  State<BrainBreakScreen> createState() => _BrainBreakScreenState();
}

class _BrainBreakScreenState extends State<BrainBreakScreen> {
  bool _loading = true;

  late Map<String, dynamic> challenge;

  final List<Map<String, dynamic>> _challenges = [
    {
      "title": "Friends Trivia",
      "emoji": "🎬",
      "color": Colors.orange,
      "time": "2 mins",
    },
    {
      "title": "Guess the Logo",
      "emoji": "🎨",
      "color": Colors.blue,
      "time": "3 mins",
    },
    {
      "title": "World Geography",
      "emoji": "🌍",
      "color": Colors.green,
      "time": "2 mins",
    },
    {
      "title": "Marvel Quiz",
      "emoji": "🦸",
      "color": Colors.red,
      "time": "3 mins",
    },
    {
      "title": "Tech Trivia",
      "emoji": "💻",
      "color": Colors.indigo,
      "time": "2 mins",
    },
  ];

  @override
  void initState() {
    super.initState();

    challenge = _challenges[Random().nextInt(_challenges.length)];

    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
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
            builder: (_, value, child) {
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
            ),
          ),
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _challengeView() {
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
              Text(
                challenge["emoji"],
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 20),
              Text(
                "Today's Challenge",
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                challenge["title"],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "Estimated Time • ${challenge["time"]}",
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: challenge["color"],
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.medium),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BrainBreakQuizScreen(
                          challenge: challenge,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Start Challenge",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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