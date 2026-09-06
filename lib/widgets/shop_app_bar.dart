import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopAppBar({this.showBack = false, this.showCart = true, super.key});

  final bool showBack;
  final bool showCart;

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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '龙',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 8),
              Text(
                'WUXIA',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (showCart)
          Builder(
            builder: (context) {
              final cart = CartScope.of(context);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Open cart',
                    onPressed: () => context.push('/cart'),
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 2,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        IconButton(
          tooltip: ThemeModeScope.of(context).isDark
              ? 'Switch to light mode'
              : 'Switch to dark mode',
          onPressed: ThemeModeScope.of(context).onToggle,
          icon: Icon(
            ThemeModeScope.of(context).isDark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
