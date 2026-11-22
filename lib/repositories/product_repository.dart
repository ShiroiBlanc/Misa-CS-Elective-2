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
        .from('products')
        .select(
          'id, name, description, price, stock, image_url, '
          'categories!inner(name)',
        )
        .gte('price', minimumPrice)
        .lte('price', maximumPrice);
    if (search.isNotEmpty) query = query.ilike('name', '%$search%');
    if (category != null) query = query.eq('categories.name', category);
    query = query.order(
      sort == 'price_low' || sort == 'price_high' ? 'price' : 'created_at',
      ascending: sort != 'price_high',
    );
    final response = await query.range(start, end);
    dynamic countQuery = supabase
        .from('products')
        .select('id, categories!inner(name)')
        .gte('price', minimumPrice)
        .lte('price', maximumPrice);
    if (search.isNotEmpty) {
      countQuery = countQuery.ilike('name', '%$search%');
    }
    if (category != null) {
      countQuery = countQuery.eq('categories.name', category);
    }
    final countRows = await countQuery;

    final products = <Product>[];
    for (final row in (response as List<dynamic>)) {
      products.add(_productFromRow(Map<String, dynamic>.from(row as Map)));
    }
    return ProductPage(products: products, totalCount: countRows.length);
  }

  Future<Product> fetchProduct(String id) async {
    final localProduct = localBooks.where((book) => book.id == id);
    if (localProduct.isNotEmpty) return localProduct.first;

    final response = await supabase
        .from('products')
        .select(
          'id, name, description, price, stock, image_url, categories!inner(name)',
        )
        .eq('id', id)
        .single();
    return _productFromRow(Map<String, dynamic>.from(response as Map));
  }

  Product _productFromRow(Map<String, dynamic> row) {
    final normalized = Map<String, dynamic>.from(row);
    return Product.fromMap(normalized);
  }
}
