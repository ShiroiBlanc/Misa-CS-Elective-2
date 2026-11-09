import '../main.dart';
import '../models/product.dart';

class ProductPage {
  const ProductPage({required this.products, required this.totalCount});

  final List<Product> products;
  final int totalCount;
}

class ProductRepository {
  Future<ProductPage> fetchProducts({
    required int page,
    required int pageSize,
    required double minimumPrice,
    required double maximumPrice,
    String search = '',
    String? category,
    String sort = 'newest',
  }) async {
    final start = page * pageSize;
    final end = start + pageSize - 1;
    dynamic query = supabase
        .from('listings')
        .select(
          'id, title, description, price, category, condition, '
          'listing_images(storage_path)',
        )
        .eq('status', 'active')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice);
    if (search.isNotEmpty) query = query.ilike('title', '%$search%');
    if (category != null) query = query.eq('category', category);
    query = query.order(
      sort == 'price_low' || sort == 'price_high' ? 'price' : 'created_at',
      ascending: sort != 'price_high',
    );
    final response = await query.range(start, end);
    dynamic countQuery = supabase
        .from('listings')
        .select('id')
        .eq('status', 'active')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice);
    if (search.isNotEmpty) countQuery = countQuery.ilike('title', '%$search%');
    if (category != null) countQuery = countQuery.eq('category', category);
    final countRows = await countQuery;

    final products = <Product>[];
    for (final row in (response as List<dynamic>)) {
      products.add(_productFromRow(Map<String, dynamic>.from(row as Map)));
    }
    if (countRows.isEmpty) {
      final filtered = localBooks
          .where(
            (book) => book.price >= minimumPrice && book.price <= maximumPrice,
          )
          .where(
            (book) =>
                search.isEmpty ||
                book.name.toLowerCase().contains(search.toLowerCase()),
          )
          .where((book) => category == null || book.category == category)
          .toList();
      if (sort == 'price_low') {
        filtered.sort((a, b) => a.price.compareTo(b.price));
      } else if (sort == 'price_high') {
        filtered.sort((a, b) => b.price.compareTo(a.price));
      }
      final localStart = page * pageSize;
      final localEnd = (localStart + pageSize).clamp(0, filtered.length);
      return ProductPage(
        products: localStart >= filtered.length
            ? const []
            : filtered.sublist(localStart, localEnd),
        totalCount: filtered.length,
      );
    }

    return ProductPage(products: products, totalCount: countRows.length);
  }

  Future<Product> fetchProduct(String id) async {
    final localProduct = localBooks.where((book) => book.id == id);
    if (localProduct.isNotEmpty) return localProduct.first;

    final response = await supabase
        .from('listings')
        .select(
          'id, title, description, price, category, condition, '
          'listing_images(storage_path)',
        )
        .eq('id', id)
        .eq('status', 'active')
        .single();
    return _productFromRow(Map<String, dynamic>.from(response as Map));
  }

  Product _productFromRow(Map<String, dynamic> row) {
    final images = row['listing_images'];
    final path = images is List && images.isNotEmpty
        ? images.first['storage_path'] as String?
        : null;
    final normalized = Map<String, dynamic>.from(row);
    if (path != null) {
      normalized['image_url'] = supabase.storage
          .from('listing-images')
          .getPublicUrl(path);
    }
    return Product.fromMap(normalized);
  }
}
