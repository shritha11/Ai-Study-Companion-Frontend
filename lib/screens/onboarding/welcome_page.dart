import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        child: Column(
          children: [

            const Spacer(),

            const Icon(
              Icons.auto_awesome,
              size: 90,
            ),

            const SizedBox(height: 30),

            const Text(
              "Let's make\nEunoia yours",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "We'll personalize your learning experience in less than a minute.",
              textAlign: TextAlign.center,
            ),

            const Spacer(),

          ],
        ),
      ),
    );
  }
}