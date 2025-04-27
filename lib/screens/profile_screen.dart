import 'package:flutter/material.dart';
import 'package:appparcial/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userData;

    final nombre = user?['nombre'] ?? '';
    final apellido = user?['apellido'] ?? '';
    final correo = user?['correo'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF0A84FF),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              '$nombre $apellido',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              correo,
              style: const TextStyle(color: Colors.white70),
            ),
            const Divider(height: 40, color: Colors.white30),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text('Mis Órdenes', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white54),
              onTap: () => Navigator.pushNamed(context, 'orders'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              tileColor: const Color(0xFF2C2C2E),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
