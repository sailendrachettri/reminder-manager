import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        toolbarHeight: 38,
        centerTitle: false,

        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: AppColors.primary,
        ),
      ),

      chipTheme: ChipThemeData(
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        backgroundColor: Colors.white,
        /*For unselected */
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: AppColors.primary,
          height: 1,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        /*For selected */
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1,
          leadingDistribution: TextLeadingDistribution.even,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.primary, width: 1),
        ),
        
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      ),

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
