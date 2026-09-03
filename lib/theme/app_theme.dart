import 'package:flutter/material.dart';

const tabletBreakpoint = 680.0;
const desktopBreakpoint = 1000.0;

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1689E8),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF1F1F1F),
  fontFamily: 'serif',
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      fontSize: 32,
      height: 1.05,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 26,
      height: 1.05,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      height: 1.5,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Arial',
      fontSize: 12,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Arial',
      fontWeight: FontWeight.w700,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF62B7F5),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121216),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontFamily: 'serif',
      fontSize: 21,
      fontWeight: FontWeight.w700,
      letterSpacing: 3,
      color: Colors.white,
    ),
  ),
  cardTheme: const CardThemeData(
    elevation: 0,
    color: Color(0xFF2B2B2B),
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
);
