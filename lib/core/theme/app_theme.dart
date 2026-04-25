import 'package:flutter/material.dart';
import 'package:commitlock/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.background,
    primaryColor: LightColors.primary,

    appBarTheme: const AppBarTheme(
      backgroundColor: LightColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    cardColor: LightColors.card,
    dividerColor: LightColors.border,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: LightColors.textPrimary),
      bodyMedium: TextStyle(color: LightColors.textSecondary),
    ),

    // Optional: remove splash/overlays if you're fully custom UI
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
  //DARK COLOR THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkColors.background,
    primaryColor: DarkColors.primary,

    appBarTheme: const AppBarTheme(
      backgroundColor: DarkColors.card,
      foregroundColor: DarkColors.textPrimary,
      elevation: 0,
    ),

    cardColor: DarkColors.card,
    dividerColor: DarkColors.border,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkColors.textPrimary),
      bodyMedium: TextStyle(color: DarkColors.textSecondary),
    ),

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}
