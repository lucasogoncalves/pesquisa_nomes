import 'dart:async';
import 'package:flutter/material.dart';

class AvisoINPI extends StatefulWidget {
  const AvisoINPI({super.key});

  @override
  State<AvisoINPI> createState() => AvisoINPIState();
}

class AvisoINPIState extends State<AvisoINPI> {
  bool _ativo = false;
  bool _erroMostrado = false;
  Timer? _timeout;

  void ativar() {
    if (_ativo) return;

    setState(() {
      _ativo = true;
      _erroMostrado = false;
    });

    _timeout?.cancel();
    _timeout = Timer(const Duration(seconds: 60), () {
      if (mounted && _ativo && !_erroMostrado) {
        _erroMostrado = true;
        _ativo = false;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('❌ INPI indisponível'),
            content: const Text(
              'O site do INPI pode estar lento ou fora do ar.\n'
              'Tente novamente mais tarde ou recarregue a aba.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          ),
        );
      }
    });
  }

  void resolver() {
    _timeout?.cancel();
    if (_ativo) {
      setState(() {
        _ativo = false;
      });
    }
  }

  @override
  void dispose() {
    _timeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ativo) return const SizedBox.shrink();

    return Card(
  margin: const EdgeInsets.all(16),
  color: Colors.white,
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: const [
        CircularProgressIndicator(),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            'Aguarde alguns segundos... o INPI está carregando.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  ),
);

  }
}
