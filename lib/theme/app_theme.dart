import 'package:flutter/material.dart';

const tabletBreakpoint = 680.0;
const desktopBreakpoint = 1000.0;

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF274C45)),
  scaffoldBackgroundColor: const Color(0xFFF7F5F0),
  fontFamily: 'Georgia',
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF7F5F0),
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  ),
  cardTheme: const CardThemeData(
    elevation: 0,
    color: Colors.white,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
    ),
  ),
);
