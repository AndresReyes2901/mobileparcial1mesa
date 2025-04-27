import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appparcial/providers/cart_provider.dart';
import 'package:appparcial/providers/product_provider.dart';
import 'package:appparcial/models/product.dart';
import 'voice_cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = '';
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
      context.read<CartProvider>().loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: _isSearchVisible ? _buildSearchField() : const Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(_isSearchVisible ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) _searchQuery = '';
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VoiceCartScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, prov, _) {
          if (prov.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (prov.error != null) {
            return Center(
              child: Text(
                'Error: ${prov.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final filtered = prov.products
              .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          if (filtered.isEmpty) {
            return const Center(
              child: Text(
                'No hay productos',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final p = filtered[i];
              return Card(
                color: const Color(0xFF2C2C2E),
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            p.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            p.description,
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$${p.finalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton(
                              onPressed: () {
                                context.read<CartProvider>().addProduct(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${p.name} agregado al carrito')),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Color(0xFF0A84FF)),
                                textStyle: const TextStyle(fontSize: 12),
                              ),
                              child: const Text('Agregar'),
                            ),
                          ],
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

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Buscar producto...',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      onChanged: (query) => setState(() => _searchQuery = query),
    );
  }
}
