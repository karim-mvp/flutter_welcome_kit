import 'package:flutter/material.dart';

class TourStep {
  final GlobalKey key;
  final String title;
  final String description;
  final Color backgroundColor;
  final Duration duration;
  final String? buttonLabel;
  final bool isLast;
  final Color? buttonBackgroundColor;
  final Color? foregroundColor;
  final String? skipText;
  final Color? skipColor;
  final String? fontFamily;

  const TourStep({
    required this.key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(seconds: 4),
    this.buttonLabel,
    this.isLast = false,
    this.buttonBackgroundColor,
    this.foregroundColor,
    this.skipColor,
    this.skipText,
    this.fontFamily,
  });
}
