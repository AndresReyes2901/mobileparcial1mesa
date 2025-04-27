import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PasswordResetConfirmScreen extends StatefulWidget {
  final String uid;
  final String token;

  const PasswordResetConfirmScreen({
    super.key,
    required this.uid,
    required this.token,
  });

  @override
  State<PasswordResetConfirmScreen> createState() =>
      _PasswordResetConfirmScreenState();
}

class _PasswordResetConfirmScreenState
    extends State<PasswordResetConfirmScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Nueva contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField(_passCtrl, 'Nueva contraseña', isPassword: true),
            const SizedBox(height: 16),
            _buildField(_confirmCtrl, 'Confirmar contraseña', isPassword: true),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              onPressed: auth.loading
                  ? null
                  : () async {
                final ok = await auth.confirmPasswordReset(
                  uid: widget.uid,
                  token: widget.token,
                  newPassword: _passCtrl.text.trim(),
                  confirmPassword: _confirmCtrl.text.trim(),
                );
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Contraseña restablecida con éxito')),
                  );
                  Navigator.pushReplacementNamed(context, 'login');
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(auth.error ?? 'Error al restablecer'),
                    ),
                  );
                }
              },
              label: auth.loading
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: ctrl,
      obscureText: isPassword,
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
