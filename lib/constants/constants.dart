import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF00B4D8);
  static const Color secondaryLight = Color(0xFF90E0EF);
  static const Color accentLight = Color(0xFF0077B6);
  static const Color backgroundLight = Color(0xFFF8F9FA);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF0096C7);
  static const Color secondaryDark = Color(0xFF48CAE4);
  static const Color accentDark = Color(0xFF00B4D8);
  static const Color backgroundDark = Color(0xFF121212);

  // Common Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color danger = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);
}

class AppTextStyles {
  static TextStyle headline1(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
      );

  static TextStyle bodyText(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontFamily: 'OpenSans',
      );
}