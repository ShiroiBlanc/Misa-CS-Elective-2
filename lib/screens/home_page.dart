import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image.dart';
import '../widgets/shop_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(productCatalogProvider);
    return Scaffold(
      appBar: const ShopAppBar(),
      body: catalog.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _CatalogError(
          message: error.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(productCatalogProvider),
        ),
        data: (state) => LayoutBuilder(
          builder: (context, constraints) => Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: constraints.maxWidth > 980 ? 980 : constraints.maxWidth,
              height: constraints.maxHeight,
              child: _CatalogContent(state: state),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogContent extends ConsumerStatefulWidget {
  const _CatalogContent({required this.state});

  final ProductCatalogState state;

  @override
  ConsumerState<_CatalogContent> createState() => _CatalogContentState();
}

class _CatalogContentState extends ConsumerState<_CatalogContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.state.search;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading =
        ref.watch(productCatalogProvider).isLoading ||
        widget.state.isPageLoading;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - 40;
        final columns = width >= desktopBreakpoint
            ? 5
            : width >= tabletBreakpoint
            ? 3
            : 2;
        final cellWidth = (width - ((columns - 1) * 16)) / columns;
        return Column(
          children: [
            if (widget.state.featuredProducts.isNotEmpty)
              _FeaturedRow(products: widget.state.featuredProducts),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: const InputDecoration(
                        hintText: 'Search books, authors, or titles',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _applyFilters(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.tonalIcon(
                    onPressed: loading ? null : () => _showFilters(context),
                    icon: const Icon(Icons.tune),
                    label: const Text('Filters'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.state.products.isEmpty
                  ? const Center(child: Text('No books match your filters.'))
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      itemCount: widget.state.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,
                        mainAxisExtent: cellWidth / .8 + 104,
                      ),
                      itemBuilder: (context, index) => ProductCard(
                        key: ValueKey(widget.state.products[index].id),
                        product: widget.state.products[index],
                      ),
                    ),
            ),
            _Pagination(state: widget.state, loading: loading),
          ],
        );
      },
    );
  }

  void _applyFilters(BuildContext context) {
    final current = widget.state;
    ref
        .read(productCatalogProvider.notifier)
        .setFilters(
          range: RangeValues(current.minimumPrice, current.maximumPrice),
          search: _searchController.text.trim(),
          category: current.category,
          sort: current.sort,
        );
  }

  void _showFilters(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close filters',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) => _FilterPanel(
        state: widget.state,
        onApply: (range, category, sort) {
          Navigator.of(context).pop();
          ref
              .read(productCatalogProvider.notifier)
              .setFilters(
                range: range,
                search: _searchController.text.trim(),
                category: category,
                sort: sort,
              );
        },
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
    );
  }
}

class _FilterPanel extends StatefulWidget {
  const _FilterPanel({required this.state, required this.onApply});

  final ProductCatalogState state;
  final void Function(RangeValues, String?, String) onApply;

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  late RangeValues range;
  late String? category;
  late String sort;

  @override
  void initState() {
    super.initState();
    range = RangeValues(widget.state.minimumPrice, widget.state.maximumPrice);
    category = widget.state.category;
    sort = widget.state.sort;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width > 420
              ? 390
              : MediaQuery.sizeOf(context).width * .88,
          height: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Filter books',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Price range',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '₱${range.start.toStringAsFixed(0)} – '
                    '₱${range.end.toStringAsFixed(0)}',
                  ),
                  RangeSlider(
                    values: range,
                    min: minimumProductPrice,
                    max: maximumProductPrice,
                    divisions: 40,
                    onChanged: (value) => setState(() => range = value),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String?>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('All categories'),
                      ),
                      DropdownMenuItem(value: 'wuxia', child: Text('Wuxia')),
                      DropdownMenuItem(
                        value: 'xianxia',
                        child: Text('Xianxia'),
                      ),
                      DropdownMenuItem(
                        value: 'xuanhuan',
                        child: Text('Xuanhuan'),
                      ),
                    ],
                    onChanged: (value) => setState(() => category = value),
                  ),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    initialValue: sort,
                    decoration: const InputDecoration(
                      labelText: 'Sort by',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'newest', child: Text('Newest')),
                      DropdownMenuItem(
                        value: 'price_low',
                        child: Text('Price: low to high'),
                      ),
                      DropdownMenuItem(
                        value: 'price_high',
                        child: Text('Price: high to low'),
                      ),
                    ],
                    onChanged: (value) => setState(() => sort = value!),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => widget.onApply(range, category, sort),
                      child: const Text('Apply filters'),
                    ),
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

class _Pagination extends ConsumerWidget {
  const _Pagination({required this.state, required this.loading});
  final ProductCatalogState state;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: loading || state.page == 0
              ? null
              : () => ref
                    .read(productCatalogProvider.notifier)
                    .goToPage(state.page - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text('Page ${state.page + 1} of ${state.totalPages}'),
        IconButton(
          onPressed: loading || state.page >= state.totalPages - 1
              ? null
              : () => ref
                    .read(productCatalogProvider.notifier)
                    .goToPage(state.page + 1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    ),
  );
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.cloud_off, size: 48),
        const SizedBox(height: 12),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 16),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    ),
  );
}

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final featured = products.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          const featureHeight = 244.0;
          final featuredCard = SizedBox(
            width: compact ? double.infinity : constraints.maxWidth * .6,
            height: compact ? 170 : featureHeight,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductImage(product: featured),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .88),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: compact ? 270 : 360,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FEATURED BOOK',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Arial',
                                fontSize: 12,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              featured.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Physical edition · ${featured.conditionLabel}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    featuredCard,
                    const SizedBox(height: 10),
                    _Announcements(products: products),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    featuredCard,
                    const SizedBox(width: 20),
                    SizedBox(
                      width: constraints.maxWidth * .4 - 20,
                      height: featureHeight,
                      child: _Announcements(products: products),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _Announcements extends StatelessWidget {
  const _Announcements({required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Announcements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Text('View all', style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        const SizedBox(height: 10),
        ...products
            .take(4)
            .map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
