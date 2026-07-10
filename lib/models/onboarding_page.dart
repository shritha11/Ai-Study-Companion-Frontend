import 'package:flutter/material.dart';

class OnboardingPageModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> options;

  const OnboardingPageModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.options,
  });
}