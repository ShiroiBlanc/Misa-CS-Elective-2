import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/auth_gate.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';

class WuxiaApp extends ConsumerWidget {
  const WuxiaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Wuxia',
      debugShowCheckedModeBanner: false,
      theme: lightAppTheme,
      darkTheme: appTheme,
      themeMode: themeMode,
      home: const AuthGate(),
    );
  }
}
