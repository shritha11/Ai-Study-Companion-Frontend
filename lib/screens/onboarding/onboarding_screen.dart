import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'study_page.dart';
import 'learner_page.dart';
import 'goal_page.dart';
import 'finish_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final controller = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (page) {
          setState(() {
            currentPage = page;
          });
        },
        children: const [
        WelcomePage(),
        StudyPage(),
        LearnerPage(),
        GoalPage(),
        FinishPage(),
     ],
      ),
    );
  }
}