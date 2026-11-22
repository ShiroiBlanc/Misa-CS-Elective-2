import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../widgets/shop_app_bar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<Map<String, dynamic>>> _products;
  late Future<List<Map<String, dynamic>>> _orders;

  @override
  void initState() {
    super.initState();
    _products = _loadProducts();
    _orders = _loadOrders();
  }

  Future<List<Map<String, dynamic>>> _loadProducts() async {
    final isAdmin = await supabase.rpc('is_admin') as bool? ?? false;
    if (!isAdmin) throw Exception('Only administrators can access this page.');
    final rows = await supabase
        .from('products')
        .select(
          'id, name, description, price, stock, image_url, categories(name)',
        )
        .order('created_at', ascending: false);
    return [for (final row in rows) Map<String, dynamic>.from(row)];
  }

  Future<List<Map<String, dynamic>>> _loadOrders() async {
    final rows = await supabase
        .from('orders')
        .select('id, user_id, created_at, status, total')
        .order('created_at', ascending: false);
    return [for (final row in rows) Map<String, dynamic>.from(row)];
  }

  Future<void> _addCategory() async {
    final controller = TextEditingController();
    final save = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (save != true || controller.text.trim().isEmpty) return;
    try {
      final name = controller.text.trim();
      final slug = name
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w]+'), '-')
          .replaceAll(RegExp(r'^-+|-+$'), '');
      await supabase.from('categories').upsert({
        'name': name,
        'slug': slug,
      }, onConflict: 'slug');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Category added')));
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  Future<void> _updateOrderStatus(
    Map<String, dynamic> order,
    String status,
  ) async {
    await supabase
        .from('orders')
        .update({'status': status})
        .eq('id', order['id']);
    if (mounted) setState(() => _orders = _loadOrders());
  }

  Future<void> _showProductForm([Map<String, dynamic>? product]) async {
    final name = TextEditingController(text: product?['name']?.toString());
    final description = TextEditingController(
      text: product?['description']?.toString(),
    );
    final price = TextEditingController(text: product?['price']?.toString());
    final stock = TextEditingController(
      text: product?['stock']?.toString() ?? '0',
    );
    final imageUrl = TextEditingController(
      text: product?['image_url']?.toString() ?? '',
    );
    final categories = await supabase
        .from('categories')
        .select('id, name')
        .order('name');
    if (!mounted) return;
    final categoryByName = {
      for (final row in categories) row['name'].toString(): row['id'],
    };
    var category =
        product?['categories']?['name']?.toString() ??
        (categoryByName.keys.isEmpty ? null : categoryByName.keys.first);
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(product == null ? 'Add product' : 'Edit product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: description,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: stock,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stock'),
                ),
                TextField(
                  controller: imageUrl,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    helperText: 'Or upload an image below',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (picked == null) return;
                    try {
                      final bytes = await picked.readAsBytes();
                      final extension = picked.name.split('.').last;
                      final fileName =
                          '${DateTime.now().millisecondsSinceEpoch}.${extension.isEmpty ? 'jpg' : extension}';
                      await supabase.storage
                          .from('product-images')
                          .uploadBinary(
                            fileName,
                            bytes,
                            fileOptions: const FileOptions(
                              cacheControl: '3600',
                              upsert: false,
                            ),
                          );
                      imageUrl.text = supabase.storage
                          .from('product-images')
                          .getPublicUrl(fileName);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image uploaded')),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Upload Supabase image'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categoryByName.keys
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) => setDialogState(() => category = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final values = {
                  'name': name.text.trim(),
                  'description': description.text.trim(),
                  'price': double.tryParse(price.text) ?? -1,
                  'stock': int.tryParse(stock.text) ?? -1,
                  'category_id': categoryByName[category],
                  'image_url': imageUrl.text.trim().isEmpty
                      ? null
                      : imageUrl.text.trim(),
                };
                try {
                  if (values['name'] == '' ||
                      (values['price'] as double) < 0 ||
                      (values['stock'] as int) < 0 ||
                      values['category_id'] == null) {
                    throw Exception('Complete all fields with valid values.');
                  }
                  if (product == null) {
                    await supabase.from('products').insert(values);
                  } else {
                    await supabase
                        .from('products')
                        .update(values)
                        .eq('id', product['id']);
                  }
                  if (context.mounted) Navigator.pop(context);
                  if (mounted) setState(() => _products = _loadProducts());
                } on PostgrestException catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  }
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.toString())));
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteProduct(Map<String, dynamic> product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Delete ${product['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      await supabase.from('products').delete().eq('id', product['id']);
      if (mounted) setState(() => _products = _loadProducts());
    } on PostgrestException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(showBack: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showProductForm,
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final products = snapshot.data ?? const [];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Admin products',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: _addCategory,
                  icon: const Icon(Icons.category_outlined),
                  label: const Text('Add category'),
                ),
              ),
              const SizedBox(height: 12),
              for (final product in products)
                Card(
                  child: ListTile(
                    title: Text(product['name'].toString()),
                    subtitle: Text(
                      '${product['categories']?['name'] ?? ''} · '
                      '₱${product['price']} · stock ${product['stock']}',
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () => _showProductForm(product),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _deleteProduct(product),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              Text('Orders', style: Theme.of(context).textTheme.headlineSmall),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _orders,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LinearProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Unable to load orders: ${snapshot.error}');
                  }
                  return Column(
                    children: [
                      for (final order in snapshot.data ?? const [])
                        Card(
                          child: ListTile(
                            title: Text('Order #${order['id']}'),
                            subtitle: Text(
                              'User ${order['user_id']} · ₱${order['total']}',
                            ),
                            trailing: DropdownButton<String>(
                              value: order['status'] as String,
                              items: const [
                                DropdownMenuItem(
                                  value: 'pending',
                                  child: Text('Pending'),
                                ),
                                DropdownMenuItem(
                                  value: 'done',
                                  child: Text('Done'),
                                ),
                                DropdownMenuItem(
                                  value: 'cancelled',
                                  child: Text('Cancelled'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  _updateOrderStatus(order, value);
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
