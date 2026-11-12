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
      actions: [
        IconButton(
          tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
          onPressed: ref.read(themeModeProvider.notifier).toggle,
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
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
      ],
    );
  }
}
