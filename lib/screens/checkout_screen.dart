import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/payment_service.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  Future<void> _startCheckout(BuildContext context) async {
    try {
      final url = await PaymentService().createCheckoutSession();
      final uri = Uri.parse(url);

      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir la URL de pago');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Revisa tu correo para ver el recibo.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error iniciando pago: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2C2E),
        title: const Text('Pago con Stripe'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.payment),
          onPressed: () => _startCheckout(context),
          label: const Text('Pagar ahora'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            backgroundColor: const Color(0xFF0A84FF),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
