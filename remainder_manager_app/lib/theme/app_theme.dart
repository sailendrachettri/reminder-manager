import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      expansionTileTheme: ExpansionTileThemeData(
        iconColor: AppColors.primary,
        collapsedIconColor: const Color.fromARGB(255, 61, 84, 103),
      ),

      textTheme: const TextTheme(
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 12),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
    );
  }
}
