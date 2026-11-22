import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../main.dart';
import '../providers/theme_provider.dart';

class ShopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ShopAppBar({this.showBack = false, super.key});

  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final compact = MediaQuery.sizeOf(context).width < 600;
    final actions = <Widget>[
      FutureBuilder<bool>(
        future: supabase.rpc('is_admin'),
        builder: (context, snapshot) {
          if (snapshot.data != true) return const SizedBox.shrink();
          return IconButton(
            tooltip: 'Admin',
            onPressed: () => context.push('/admin'),
            icon: const Icon(Icons.admin_panel_settings_outlined),
          );
        },
      ),
      IconButton(
        tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
        onPressed: ref.read(themeModeProvider.notifier).toggle,
        icon: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        ),
      ),
      IconButton(
        tooltip: 'Cart',
        onPressed: () => context.push('/cart'),
        icon: const Icon(Icons.shopping_cart_outlined),
      ),
      IconButton(
        tooltip: 'Order history',
        onPressed: () => context.push('/orders'),
        icon: const Icon(Icons.receipt_long_outlined),
      ),
      IconButton(
        tooltip: 'Sign out',
        onPressed: () async {
          try {
            await supabase.auth.signOut();
          } on AuthException catch (error) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error.message)));
            }
          }
        },
        icon: const Icon(Icons.logout),
      ),
      const SizedBox(width: 12),
    ];
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      leading: showBack
          ? IconButton(
              tooltip: 'Back to shop',
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('龙', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(width: 8),
            Text('WUXIA', style: Theme.of(context).appBarTheme.titleTextStyle),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: isDark ? Colors.white24 : Colors.black12,
          height: 1,
        ),
      ),
      actions: compact
          ? [
              IconButton(
                tooltip: 'Cart',
                onPressed: () => context.push('/cart'),
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              FutureBuilder<bool>(
                future: supabase.rpc('is_admin'),
                builder: (context, snapshot) => PopupMenuButton<String>(
                  tooltip: 'More',
                  onSelected: (value) async {
                    if (value == 'admin') {
                      context.push('/admin');
                    } else if (value == 'theme') {
                      ref.read(themeModeProvider.notifier).toggle();
                    } else if (value == 'orders') {
                      context.push('/orders');
                    } else if (value == 'signout') {
                      await supabase.auth.signOut();
                    }
                  },
                  itemBuilder: (context) => [
                    if (snapshot.data == true)
                      const PopupMenuItem(value: 'admin', child: Text('Admin')),
                    PopupMenuItem(
                      value: 'theme',
                      child: Text(isDark ? 'Light mode' : 'Dark mode'),
                    ),
                    const PopupMenuItem(
                      value: 'orders',
                      child: Text('Order history'),
                    ),
                    const PopupMenuItem(
                      value: 'signout',
                      child: Text('Sign out'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
            ]
          : actions,
    );
  }
}
