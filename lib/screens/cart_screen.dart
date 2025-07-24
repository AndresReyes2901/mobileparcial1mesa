import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';
import '../providers/recommendation_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().loadCart();
    context.read<RecommendationProvider>().loadRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final recProv = context.watch<RecommendationProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF72585),
      appBar: AppBar(
        toolbarHeight: 70, // Por defecto son 56.0
        backgroundColor: const Color(0xFF1E1E2F),
        title: const Text(
          'Mi Carrito',
          style: TextStyle(
            color: Color(0xFFF72585),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cart.loading
          ? const Center(child: CircularProgressIndicator())
          : cart.error != null
          ? Center(
          child: Text('Error: ${cart.error}',
              style: const TextStyle(color: Colors.red)))
          : cart.items.isEmpty
          ? const Center(
          child: Text('Carrito vacío',
              style: TextStyle(color: Colors.white70)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...cart.items.map((item) => Card(
              color: const Color(0xFF2C2C2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(item.product.name,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove,
                          color: Colors.white),
                      onPressed: () =>
                          cart.decreaseQuantity(item.id),
                    ),
                    Text('${item.quantity}',
                        style: const TextStyle(color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.add,
                          color: Colors.white),
                      onPressed: () =>
                          cart.increaseQuantity(item.id),
                    ),
                  ],
                ),
                trailing: Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold),
                ),
                onLongPress: () => cart.removeItem(item.id),
              ),
            )),
            const SizedBox(height: 24),
            const Text('Recomendaciones',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: recProv.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recProv.items.length,
                itemBuilder: (_, i) {
                  final p = recProv.items[i];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: Card(
                      color: const Color(0xFF2C2C2E),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          context
                              .read<CartProvider>()
                              .addProduct(p);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                                content:
                                Text('${p.name} agregado')),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(p.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${p.finalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CheckoutScreen()),
                    );
                  },
                  label: const Text('Pagar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
