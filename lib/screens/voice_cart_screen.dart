import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../providers/cart_provider.dart';

class VoiceCartScreen extends StatefulWidget {
  const VoiceCartScreen({Key? key}) : super(key: key);

  @override
  State<VoiceCartScreen> createState() => _VoiceCartScreenState();
}

class _VoiceCartScreenState extends State<VoiceCartScreen> {
  final SpeechToText _speech = SpeechToText();
  bool _available = false;
  bool _listening = false;
  String _text = '';
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _available = await _speech.initialize();
    setState(() {});
  }

  void _startListening() {
    if (!_available) return;
    _speech.listen(onResult: (val) {
      setState(() => _text = val.recognizedWords);
    });
    setState(() => _listening = true);
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _listening = false);
  }

  Future<void> _sendCommand() async {
    if (_text.isEmpty) return;
    setState(() => _processing = true);

    final provider = context.read<CartProvider>();
    try {
      await provider.processVoiceCommand(_text);
      if (mounted) {
        if (provider.lastAddedItems.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Agregado: ${provider.lastAddedItems}')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se identificaron productos')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMsg = e.toString();
        if (errorMsg.contains('No se encontraron productos')) {
          errorMsg = 'No se encontraron productos que coincidan con "$_text"';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMsg')),
        );
      }
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF72585),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2F),
        title: const Text(
          'Agregar por voz',
          style: TextStyle(
            color: Color(0xFFF72585),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  _text.isEmpty
                      ? 'Pulsa el micrófono e indica productos'
                      : _text,
                  style: const TextStyle(
                      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(_listening ? Icons.mic_off : Icons.mic),
              label: Text(_listening ? 'Detener' : 'Escuchar'),
              onPressed: _listening ? _stopListening : _startListening,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              onPressed: _text.isEmpty || _processing ? null : _sendCommand,
              label: const Text('Agregar al carrito'),
            ),
          ],
        ),
      ),
    );
  }
}
