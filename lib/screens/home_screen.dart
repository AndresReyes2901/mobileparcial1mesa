// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0C56DB),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF2911A).withOpacity(0.9),
//         title: const Text(
//           'Smart Cart',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(20),
//         children: [

//           // Sección de Estado
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   '¡Bienvenido a Whorsho!',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF0C56DB), // Azul marca
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Descubrí productos de calidad para potenciar tu setup.',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),
//           // Banner Promocional
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               image: const DecorationImage(
//                 image: AssetImage('assets/images/pc_promo_banner.png'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),

          

//           // Botones rápidos
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _QuickActionButton(icon: Icons.memory, label: 'RAM'),
//               _QuickActionButton(icon: Icons.sd_storage, label: 'Discos'),
//               _QuickActionButton(icon: Icons.monitor, label: 'Monitores'),
//               _QuickActionButton(icon: Icons.keyboard, label: 'Periféricos'),
//             ],
//           ),
//           const SizedBox(height: 30),

//           // Sección inferior informativa
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF2911A),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Row(
//               children: const [
//                 Icon(Icons.local_shipping, color: Colors.white),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     'Envíos rápidos y seguros a todo el país. Comprá hoy, recibí mañana.',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _QuickActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;

//   const _QuickActionButton({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Color(0xFF0A84FF),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: Icon(icon, color: Colors.white, size: 24),
//         ),
//         const SizedBox(height: 8),
//         Text(label, style: const TextStyle(color: Colors.white70)),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // fondo claro base
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2F), // fondo oscuro
        elevation: 1,
        title: const Text(
          'Whorshop',
          style: TextStyle(
            color: Color(0xFFF9D423), // amarillo del logo
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF9D423)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF72585), // rosa
              Color(0xFF7209B7), // morado
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildBanner(),
            const SizedBox(height: 16),
            _buildWelcomeCard(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 32),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFFF72585), // rosa
                Color(0xFF7209B7), // morado
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Text(
              '¡Bienvenido a Whorshop!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // será sobrescrito por el shader
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/pc_promo_banner.png',
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.memory, 'label': 'RAM'},
      {'icon': Icons.sd_storage, 'label': 'Discos'},
      {'icon': Icons.monitor, 'label': 'Monitores'},
      {'icon': Icons.keyboard, 'label': 'Periféricos'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      children: actions.map((action) {
        return _QuickActionChip(
          icon: action['icon'] as IconData,
          label: action['label'] as String,
        );
      }).toList(),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF72585), // rosa fuerte
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.local_shipping, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Envíos rápidos y seguros a todo el país. Comprá hoy, recibí mañana.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickActionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFF9D423), size: 20), // amarillo botón
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
