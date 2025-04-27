import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PasswordResetRequestScreen extends StatefulWidget {
  const PasswordResetRequestScreen({super.key});

  @override
  State<PasswordResetRequestScreen> createState() =>
      _PasswordResetRequestScreenState();
}

class _PasswordResetRequestScreenState
    extends State<PasswordResetRequestScreen> {
  final _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Recuperar contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_emailCtrl, 'Correo electrónico'),
            const SizedBox(height: 24),
            auth.loading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              icon: const Icon(Icons.send),
              onPressed: () async {
                final ok = await auth.requestPasswordReset(
                  _emailCtrl.text.trim(),
                );
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Revisa tu correo para el enlace de recuperación')),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            auth.error ?? 'Error al procesar solicitud')),
                  );
                }
              },
              label: const Text('Enviar enlace'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2C2C2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF38383A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF38383A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0A84FF)),
        ),
      ),
    );
  }
}
