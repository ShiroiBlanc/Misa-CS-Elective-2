import 'package:flutter/material.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';
import 'models/cart.dart';

class WuxiaShopApp extends StatefulWidget {
  const WuxiaShopApp({super.key});

  @override
  State<WuxiaShopApp> createState() => _WuxiaShopAppState();
}

class _WuxiaShopAppState extends State<WuxiaShopApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  final Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wuxia',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: appTheme,
      themeMode: _themeMode,
      builder: (context, child) => CartScope(
        cart: _cart,
        child: ThemeModeScope(
          isDark: _themeMode == ThemeMode.dark,
          onToggle: () => setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          }),
          child: child!,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}

class CartScope extends InheritedNotifier<Cart> {
  const CartScope({required Cart cart, required super.child, super.key})
      : super(notifier: cart);

  static Cart of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartScope>()!.notifier!;
  }
}

class ThemeModeScope extends InheritedWidget {
  const ThemeModeScope({
    required this.isDark,
    required this.onToggle,
    required super.child,
    super.key,
  });

  final bool isDark;
  final VoidCallback onToggle;

  static ThemeModeScope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeModeScope>()!;
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) => isDark != oldWidget.isDark;
}
