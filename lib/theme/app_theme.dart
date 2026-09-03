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
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121216),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.white,
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
