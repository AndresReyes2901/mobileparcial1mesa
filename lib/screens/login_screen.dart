import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_userCtrl, 'Correo electrónico'),
            const SizedBox(height: 16),
            _buildTextField(_passCtrl, 'Contraseña', isPassword: true),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              icon: const Icon(Icons.login),
              onPressed: _handleLogin,
              label: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.pushNamed(context, 'password-reset'),
              child: const Text('¿Olvidaste tu contraseña?',
                  style: TextStyle(color: Color(0xFF0A84FF))),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, 'register'),
              child: const Text('¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Color(0xFF0A84FF))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label,
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

  Future<void> _handleLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final success = await context.read<AuthProvider>().login(
        _userCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, 'main');
      } else {
        setState(() {
          _error = 'Error al iniciar sesión';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }
}
