import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Órdenes')),
      body: Consumer<OrderProvider>(
        builder: (context, prov, _) {
          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(child: Text('Error: ${prov.error}'));
          }
          if (prov.orders.isEmpty) {
            return const Center(child: Text('No hay órdenes disponibles'));
          }
          return ListView.builder(
            itemCount: prov.orders.length,
            itemBuilder: (context, i) {
              final order = prov.orders[i];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orden #${order.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt.toLocal())}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Estado: ${order.status}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Items:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children:
                            order.items
                                .map(
                                  (item) => ListTile(
                                    title: Text(item.productName),
                                    subtitle: Text(
                                      'Cantidad: ${item.quantity}',
                                    ),
                                    trailing: Text(
                                      'ID Producto: ${item.product}',
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
