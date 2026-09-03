import 'package:flutter/material.dart';

import 'routing/app_router.dart';
import 'theme/app_theme.dart';

class WuxiaShopApp extends StatelessWidget {
  const WuxiaShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wuxia',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: appRouter,
    );
  }
}
