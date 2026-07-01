import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

import '../models/brain_break_challenge.dart';
import '../models/brain_break_questions.dart';

class BrainBreakQuizScreen extends StatefulWidget {
  final BrainBreakChallenge challenge;

  const BrainBreakQuizScreen({
    super.key,
    required this.challenge,
  });

  @override
  State<BrainBreakQuizScreen> createState() => _BrainBreakQuizScreenState();
}

class _BrainBreakQuizScreenState extends State<BrainBreakQuizScreen> {

late List<BrainBreakQuestion> questions;

  int currentQuestion = 0;
  int score = 0;
  int? selectedIndex;

  @override
  void initState() {
  super.initState();

  questions = List.from(widget.challenge.questions);
} 

  void nextQuestion() {
    if (selectedIndex == questions[currentQuestion].answer) {
      score++;
    }

    if (currentQuestion == questions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BrainBreakResultScreen(
            score: score,
            total: questions.length,
          ),
        ),
      );
      return;
    }

    setState(() {
      currentQuestion++;
      selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = questions[currentQuestion];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.challenge.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 30),

            Text(
              "Question ${currentQuestion + 1}/${questions.length}",
              style: GoogleFonts.inter(
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              q.question,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ...List.generate(
              q.options.length,
              (index) {
                final selected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(.12)
                            : AppColors.card,
                        borderRadius:
                            BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        q.options[index],
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedIndex == null ? null : nextQuestion,
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrainBreakResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const BrainBreakResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "🎉",
                style: TextStyle(fontSize: 80),
              ),

              const SizedBox(height: 20),

              Text(
                "Great Job!",
                style: GoogleFonts.inter(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "You scored",
                style: GoogleFonts.inter(),
              ),

              const SizedBox(height: 8),

              Text(
                "$score / $total",
                style: GoogleFonts.inter(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Back Home"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}