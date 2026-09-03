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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '龙',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'WUXIA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.go('/'),
          child: const Text('Library', style: TextStyle(color: Color(0xFF62B7F5))),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
