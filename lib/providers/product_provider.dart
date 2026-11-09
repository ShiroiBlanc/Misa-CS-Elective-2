import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';

const productsPerPage = 6;
const minimumProductPrice = 0.0;
const maximumProductPrice = 2000.0;

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

final productCatalogProvider =
    AsyncNotifierProvider<ProductCatalogNotifier, ProductCatalogState>(
      ProductCatalogNotifier.new,
    );

class ProductCatalogState {
  const ProductCatalogState({
    this.products = const [],
    this.featuredProducts = const [],
    this.isPageLoading = false,
    this.page = 0,
    this.totalCount = 0,
    this.minimumPrice = minimumProductPrice,
    this.maximumPrice = maximumProductPrice,
    this.search = '',
    this.category,
    this.sort = 'newest',
  });

  final List<Product> products;
  final List<Product> featuredProducts;
  final bool isPageLoading;
  final int page;
  final int totalCount;
  final double minimumPrice;
  final double maximumPrice;
  final String search;
  final String? category;
  final String sort;

  int get totalPages =>
      totalCount == 0 ? 1 : (totalCount / productsPerPage).ceil();

  ProductCatalogState copyWith({
    List<Product>? products,
    List<Product>? featuredProducts,
    bool? isPageLoading,
    int? page,
    int? totalCount,
    double? minimumPrice,
    double? maximumPrice,
    String? search,
    String? category,
    String? sort,
  }) {
    return ProductCatalogState(
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
      search: search ?? this.search,
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
}

class ProductCatalogNotifier extends AsyncNotifier<ProductCatalogState> {
  late final ProductRepository _repository = ref.read(
    productRepositoryProvider,
  );

  @override
  Future<ProductCatalogState> build() {
    return _loadPage(
      page: 0,
      minimumPrice: minimumProductPrice,
      maximumPrice: maximumProductPrice,
      search: '',
      category: null,
      sort: 'newest',
    );
  }

  Future<void> setFilters({
    required RangeValues range,
    String search = '',
    String? category,
    String sort = 'newest',
  }) async {
    state = const AsyncLoading<ProductCatalogState>();
    state = await AsyncValue.guard(
      () => _loadPage(
        page: 0,
        minimumPrice: range.start,
        maximumPrice: range.end,
        search: search,
        category: category,
        sort: sort,
      ),
    );
  }

  Future<void> goToPage(int page) async {
    final current = state.value;
    if (current == null || page < 0 || page >= current.totalPages) return;

    state = AsyncData(current.copyWith(isPageLoading: true));
    try {
      final nextState = await AsyncValue.guard(
        () => _loadPage(
          page: page,
          minimumPrice: current.minimumPrice,
          maximumPrice: current.maximumPrice,
          search: current.search,
          category: current.category,
          sort: current.sort,
          featuredProducts: current.featuredProducts,
        ),
      );
      state = nextState.when(
        data: (value) => AsyncData(value),
        error: (error, stackTrace) => AsyncError(error, stackTrace),
        loading: () => AsyncData(current.copyWith(isPageLoading: false)),
      );
    } finally {
      if (state.value != null && state.value!.isPageLoading) {
        state = AsyncData(state.value!.copyWith(isPageLoading: false));
      }
    }
  }

  Future<ProductCatalogState> _loadPage({
    required int page,
    required double minimumPrice,
    required double maximumPrice,
    String search = '',
    String? category,
    String sort = 'newest',
    List<Product>? featuredProducts,
  }) async {
    final result = await _repository.fetchProducts(
      page: page,
      pageSize: productsPerPage,
      minimumPrice: minimumPrice,
      maximumPrice: maximumPrice,
      search: search,
      category: category,
      sort: sort,
    );
    return ProductCatalogState(
      products: result.products,
      featuredProducts: featuredProducts ?? result.products,
      page: page,
      totalCount: result.totalCount,
      minimumPrice: minimumPrice,
      maximumPrice: maximumPrice,
      search: search,
      category: category,
      sort: sort,
    );
  }
}
