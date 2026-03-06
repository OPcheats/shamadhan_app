import 'package:flutter/material.dart';

/// Centralized color palette for the Shamadhan app.
class AppColors {
  AppColors._();

  // Primary colors — matches shamadhan.in CSS vars exactly
  static const Color background = Color(0xFF0A0A0A);
  static const Color accent = Color(0xFFF97316);     // Tailwind orange-500, website --accent
  static const Color accentLight = Color(0xFFFB923C); // Tailwind orange-400

  // Surface colors
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  static const Color cardBackground = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF707070);

  // Status colors
  static const Color error = Color(0xFFFF4444);
  static const Color success = Color(0xFF4CAF50);

  // Gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static final List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.35),
      offset: const Offset(0, 12),
      blurRadius: 40,
    ),
  ];

  static final List<BoxShadow> shadowGlow = [
    BoxShadow(
      color: const Color(0xFFF97316).withValues(alpha: 0.25),
      offset: const Offset(0, 12),
      blurRadius: 40,
    ),
  ];
}
