import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopAppBar({this.showBack = false, super.key});

  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
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
            Text(
              '龙',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(width: 8),
            Text(
              'WUXIA',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
