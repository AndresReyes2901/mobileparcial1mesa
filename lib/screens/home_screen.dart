import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text(
          'Smart Cart',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Banner Promocional
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/pc_promo_banner.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sección de Estado
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explora nuestras mejores ofertas en productos de hardware para PC.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Botones rápidos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QuickActionButton(icon: Icons.memory, label: 'RAM'),
              _QuickActionButton(icon: Icons.sd_storage, label: 'Discos'),
              _QuickActionButton(icon: Icons.monitor, label: 'Monitores'),
              _QuickActionButton(icon: Icons.keyboard, label: 'Periféricos'),
            ],
          ),
          const SizedBox(height: 30),

          // Sección inferior informativa
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.flash_on, color: Color(0xFF0A84FF)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Compra con envíos rápidos y seguros a todo el país.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0A84FF),
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
