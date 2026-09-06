import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image.dart';
import '../widgets/shop_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FeaturedPanels(),
                  const _SectionTitle(title: 'Browse the Library'),
                  _ProductGrid(
                    width: constraints.maxWidth > 1240
                        ? 1240
                        : constraints.maxWidth,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final contentWidth = width - 40;
    final columns = contentWidth >= desktopBreakpoint
        ? 4
        : contentWidth >= tabletBreakpoint
        ? 3
        : 2;
    final cellWidth = (contentWidth - ((columns - 1) * 16)) / columns;

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 22,
        mainAxisExtent: cellWidth / .8 + 120,
      ),
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}

class _FeaturedPanels extends StatelessWidget {
  const _FeaturedPanels();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final trending = const _TrendingPanel();
        final announcements = _AnnouncementsPanel(isDesktop: wide);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 3, child: _TrendingPanel()),
                    const SizedBox(width: 28),
                    Expanded(flex: 2, child: announcements),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [trending, const SizedBox(height: 12), announcements],
                ),
        );
      },
    );
  }
}

class _TrendingPanel extends StatelessWidget {
  const _TrendingPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trending Novels', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        const _TrendingCarousel(),
      ],
    );
  }
}

class _AnnouncementsPanel extends StatefulWidget {
  const _AnnouncementsPanel({required this.isDesktop});

  final bool isDesktop;

  @override
  State<_AnnouncementsPanel> createState() => _AnnouncementsPanelState();
}

class _AnnouncementsPanelState extends State<_AnnouncementsPanel> {

  static const _items = [
    (productIndex: 5, title: "Genius Archer's Streaming is officially released", age: '2h'),
    (productIndex: 8, title: "Ranker's Return has a new chapter", age: '1d'),
    (productIndex: 10, title: "A Blind Swordsman's Sword Coffin is now available", age: '3d'),
    (productIndex: 3, title: 'Overgeared has an updated release', age: '5d'),
  ];

  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = !widget.isDesktop;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Announcements', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
            const SizedBox(height: 12),
            if (compact)
              _buildCarousel(context)
            else
              ..._items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AnnouncementTile(item: item),
                  )),
          ],
        );
      },
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 76,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Previous announcement',
                onPressed: () => _move(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _items.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => _AnnouncementTile(item: _items[index]),
                ),
              ),
              IconButton(
                tooltip: 'Next announcement',
                onPressed: () => _move(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
        _CarouselDots(count: _items.length, active: _page),
      ],
    );
  }

  void _move(int direction) {
    final nextPage = (_page + direction) % _items.length;
    final target = nextPage < 0 ? _items.length - 1 : nextPage;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  const _AnnouncementTile({required this.item});

  final ({int productIndex, String title, String age}) item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/product/${products[item.productIndex].id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: 10),
              Text(item.age, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingCarousel extends StatefulWidget {
  const _TrendingCarousel();

  @override
  State<_TrendingCarousel> createState() => _TrendingCarouselState();
}

class _TrendingCarouselState extends State<_TrendingCarousel> {
  final PageController _controller = PageController();
  int _page = 0;
  final _trending = [0, 3, 6, 7, 11];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 258,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Previous trending novel',
                  onPressed: () => _move(-1),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _trending.length,
                    physics: const PageScrollPhysics(),
                    onPageChanged: (page) => setState(() => _page = page),
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.zero,
                      child: _TrendingCard(
                        product: products[_trending[index]],
                        rank: index + 1,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Next trending novel',
                  onPressed: () => _move(1),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
          ),
          _CarouselDots(count: _trending.length, active: _page),
        ],
      ),
    );
  }

  void _move(int direction) {
    final nextPage = (_page + direction) % _trending.length;
    final target = nextPage < 0 ? _trending.length - 1 : nextPage;
    _controller.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.product, required this.rank});

  final Product product;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/product/${product.id}'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SizedBox(width: 132, child: AspectRatio(aspectRatio: .72, child: ProductImage(product: product))),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#$rank TRENDING', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700, letterSpacing: 1)),
                    const SizedBox(height: 10),
                    Text(product.name, style: Theme.of(context).textTheme.headlineSmall, maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Text(product.genre, style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 16),
                    const Text('Popular with readers this week.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: index == active ? 20 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          decoration: BoxDecoration(
            color: index == active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: .3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
