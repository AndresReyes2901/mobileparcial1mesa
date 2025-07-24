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
      backgroundColor: const Color(0xFFF72585),
      appBar: AppBar(
        toolbarHeight: 70, // Por defecto son 56.0
        backgroundColor: const Color(0xFF1E1E2F),
        title: const Text(
          'Mis Órdenes',
          style: TextStyle(
            color: Color(0xFFF72585),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, prov, _) {
          if (prov.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(
                child: Text('Error: ${prov.error}',
                    style: const TextStyle(color: Colors.red)));
          }
          if (prov.orders.isEmpty) {
            return const Center(
                child: Text('No hay órdenes disponibles',
                    style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: prov.orders.length,
            itemBuilder: (context, i) {
              final order = prov.orders[i];
              return Card(
                color: const Color(0xFF2C2C2E),
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Orden #${order.id}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 6),
                      Text(
                        'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt.toLocal())}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text('Estado: ${order.status}',
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text(
                        'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w500),
                      ),
                      const Divider(color: Colors.white30),
                      const Text('Items:',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      ...order.items.map(
                            (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(item.productName,
                                    style: const TextStyle(color: Colors.white)),
                              ),
                              Text('x${item.quantity}',
                                  style: const TextStyle(color: Colors.white60)),
                            ],
                          ),
                        ),
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
