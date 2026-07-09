import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/study_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/lumina_bottom_nav.dart';

void main() {
  runApp(const LuminaApp());
}

class LuminaApp extends StatelessWidget {
  const LuminaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Lumina",
      theme: AppTheme.dark,
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  int currentIndex = 0;

  final List<Widget> screens = const [

    HomeScreen(),

    StudyScreen(
      sessionId: "",
    ),

    LibraryScreen(),

    ProfileScreen(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: AnimatedSwitcher(

        duration: const Duration(milliseconds: 300),

        child: IndexedStack(

          key: ValueKey(currentIndex),

          index: currentIndex,

          children: screens,

        ),

      ),

      bottomNavigationBar: LuminaBottomNav(

        currentIndex: currentIndex,

        onTap: (index){

          setState(() {

            currentIndex = index;

          });

        },

      ),

    );

  }
}