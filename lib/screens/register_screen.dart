import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Crear Cuenta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(_nombreCtrl, 'Nombre'),
            _buildTextField(_apellidoCtrl, 'Apellido'),
            _buildTextField(_correoCtrl, 'Correo electrónico'),
            _buildTextField(_passCtrl, 'Contraseña', isPassword: true),
            _buildTextField(_pass2Ctrl, 'Confirmar contraseña', isPassword: true),
            const SizedBox(height: 20),
            auth.loading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                await auth.register(
                  nombre: _nombreCtrl.text,
                  apellido: _apellidoCtrl.text,
                  correo: _correoCtrl.text,
                  password: _passCtrl.text,
                  passwordConfirm: _pass2Ctrl.text,
                );
                if (auth.error == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                  Navigator.pop(context);
                }
              },
              label: const Text('Registrarse'),
            ),
            if (auth.error != null) ...[
              const SizedBox(height: 12),
              Text(auth.error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: const Text(
                '¿Ya tienes cuenta? Inicia sesión',
                style: TextStyle(color: Color(0xFF0A84FF)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
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
      ),
    );
  }
}
