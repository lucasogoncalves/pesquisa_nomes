import 'package:flutter/material.dart';

OverlayEntry? _inpiOverlay;
bool _erroMostrado = false;
bool _visivel = true;

/// Mostra o aviso do INPI (com controle de visibilidade via `atualizarVisibilidadeAvisoINPI`)
void mostrarAvisoINPI(BuildContext context, State state) {
  
  final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != null && !currentRoute.contains('Resultado')) {
      debugPrint('⚠️ Ignorando mostrarAvisoINPI: rota atual é $currentRoute');
      return;
    }

    if (_inpiOverlay != null || !_visivel) return;

    debugPrint('🔔 mostrarAvisoINPI chamado corretamente na ResultadoScreen');

    _inpiOverlay = OverlayEntry(
      builder: (_) => _AvisoINPIWidget(),
    );
    
  Overlay.of(context, rootOverlay: true).insert(_inpiOverlay!);

  Future.delayed(const Duration(seconds: 60), () {
    if (_inpiOverlay != null && !_erroMostrado && state.mounted) {
      _erroMostrado = true;
      fecharAvisoINPI();

      showDialog(
        context: state.context,
        builder: (_) => AlertDialog(
          title: const Text('❌ INPI indisponível'),
          content: const Text(
            'O site do INPI pode estar fora do ar.\n\nEnquanto isso, veja as outras plataformas e tente novamente mais tarde.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(state.context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  });
}

/// Fecha o aviso de carregamento do INPI
void fecharAvisoINPI() {
  _inpiOverlay?.remove();
  _inpiOverlay = null;
  _erroMostrado = false;
}

/// Atualiza se o aviso do INPI deve ser visível/interagível
void atualizarVisibilidadeAvisoINPI(bool ativo) {
  _visivel = ativo;
  _inpiOverlay?.markNeedsBuild();
}

/// Widget do aviso em overlay com visibilidade condicional
class _AvisoINPIWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !_visivel,
        child: AnimatedOpacity(
          opacity: _visivel ? 1 : 0,
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
