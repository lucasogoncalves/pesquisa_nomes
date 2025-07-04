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

  /// Chame isso quando a aba INPI for ativada
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
              'O site do INPI pode estar fora do ar.\n\nEnquanto isso, veja as outras plataformas e tente novamente mais tarde.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );

        setState(() {}); // força o sumiço do aviso
      }
    });
  }

  /// Chame isso quando o script responder (pesquisa enviada ou resultado carregado)
  void resolver() {
    if (!_ativo) return;

    _timeout?.cancel();
    setState(() => _ativo = false);
  }

  @override
  void dispose() {
    _timeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ativo) return const SizedBox.shrink();

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 300),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text(
                      'Buscando no INPI...',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Isso pode levar alguns segundos.',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
