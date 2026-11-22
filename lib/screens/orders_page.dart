import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/shop_app_bar.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  Future<List<Map<String, dynamic>>> _loadOrders() async {
    final rows = await supabase
        .from('orders')
        .select(
          'id, created_at, status, total, order_items(quantity, unit_price, products(name))',
        )
        .order('created_at', ascending: false);
    return [for (final row in rows) Map<String, dynamic>.from(row)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(showBack: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Unable to load orders: ${snapshot.error}'),
            );
          }
          final orders = snapshot.data ?? const [];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = (order['order_items'] as List?) ?? const [];
              return Card(
                child: ExpansionTile(
                  title: Text('Order #${order['id']}'),
                  subtitle: Text('${order['status']} · ₱${order['total']}'),
                  children: [
                    for (final item in items)
                      ListTile(
                        title: Text(
                          item['products']?['name']?.toString() ?? 'Product',
                        ),
                        trailing: Text('×${item['quantity']}'),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
