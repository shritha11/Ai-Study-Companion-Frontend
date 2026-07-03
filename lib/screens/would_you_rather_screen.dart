import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../models/would_you_rather_item.dart';
import '../services/would_you_rather_service.dart'; // Make sure this path is exactly correct

class WouldYouRatherScreen extends StatefulWidget {
  const WouldYouRatherScreen({super.key});

  @override
  State<WouldYouRatherScreen> createState() => _WYRScreenState();
}

class _WYRScreenState extends State<WouldYouRatherScreen> {
  bool _loading = true;
  bool _isGameOver = false;
  int _current = 0;
  int? _selectedOption; 
  bool _answered = false;

  late List<WouldYouRatherItem> _items; // Fixed type here
  late int _randomPercentA;
  late int _randomPercentB;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    final fetched = await WYRService.loadRandomGame();
    if (!mounted) return;
    setState(() {
      _items = fetched;
      _current = 0;
      _selectedOption = null;
      _answered = false;
      _isGameOver = false;
      if (_items.isNotEmpty) {
        _generateRandomPercentages();
      }
      _loading = false;
    });
  }

  void _generateRandomPercentages() {
    _randomPercentA = Random().nextInt(41) + 30; 
    _randomPercentB = 100 - _randomPercentA;
  }

  void _next() {
    if (_current == _items.length - 1) {
      setState(() => _isGameOver = true);
      return;
    }
    setState(() {
      _current++;
      _answered = false;
      _selectedOption = null;
      _generateRandomPercentages();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_items.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            "No scenarios found. Check your wyr.json configuration!",
            style: GoogleFonts.inter(color: AppColors.textPrimary),
          ),
        ),
      );
    }

    if (_isGameOver) return _buildCompletionView();

    final item = _items[_current];

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
          "Would You Rather",
          style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Dilemma ${_current + 1} / ${_items.length}",
                style: GoogleFonts.inter(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
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
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOptionCard(item.optionA, 0, _randomPercentA),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CircleAvatar(
                        backgroundColor: AppColors.border,
                        radius: 24,
                        child: Text(
                          "OR",
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    _buildOptionCard(item.optionB, 1, _randomPercentB),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedOption == null ? Colors.grey.shade400 : AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
                  ),
                  onPressed: _selectedOption == null ? null : (_answered ? _next : () => setState(() => _answered = true)),
                  child: Text(
                    _answered ? "Next Scenario →" : "Submit Choice",
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String text, int index, int percentage) {
    final isSelected = _selectedOption == index;
    Color borderColor = AppColors.border;
    Color bgColor = AppColors.card;

    if (_answered) {
      bgColor = isSelected ? AppColors.primary.withOpacity(0.12) : AppColors.card;
      borderColor = isSelected ? AppColors.primary : AppColors.border;
    } else if (isSelected) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withOpacity(0.06);
    }

    return Expanded(
      child: GestureDetector(
        onTap: _answered ? null : () => setState(() => _selectedOption = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
              if (_answered)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      "$percentage%",
                      style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.primary),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionView() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: Text("🧠", style: TextStyle(fontSize: 80))),
            const SizedBox(height: 24),
            Text(
              "Mind Expanded!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              "You've weighed the options and completed the split-second decisions scenario challenge.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
              ),
              onPressed: _loadGame,
              child: Text("Play Again", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.border, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.medium)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Back Home", style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }
}