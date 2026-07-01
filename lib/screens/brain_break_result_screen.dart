class BrainBreakResultScreen extends StatelessWidget {
  final int score;
  final int total;

  const BrainBreakResultScreen({
    super.key,
    required this.score,
    required this.total,
  });

  String get message {
    final percent = score / total;

    if (percent == 1) {
      return "Perfect Score! 🏆";
    } else if (percent >= 0.8) {
      return "Awesome Work! 🎉";
    } else if (percent >= 0.6) {
      return "Nice Job! 👏";
    } else if (percent >= 0.4) {
      return "Good Try! 💪";
    }

    return "Keep Going! 🌱";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "🧠",
                      style: TextStyle(fontSize: 56),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "You scored",
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "$score / $total",
                  style: GoogleFonts.inter(
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "${((score / total) * 100).round()}%",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.home_rounded),
                    label: const Text("Back Home"),
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}