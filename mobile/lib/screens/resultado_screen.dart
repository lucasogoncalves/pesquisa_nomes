// lib/screens/resultado_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:diacritic/diacritic.dart';
import 'package:verificadordenomes/inpi_script.dart';
import 'package:verificadordenomes/widgets/aviso_inpi.dart';


class ResultadoScreen extends StatefulWidget {
  final String nome;
  final Map<String, bool> resultados;
  final Function(String, bool) onResultadoChange;

  const ResultadoScreen({
    super.key,
    required this.nome,
    required this.resultados,
    required this.onResultadoChange,
  });

  @override
  State<ResultadoScreen> createState() => _ResultadoScreenState();
}

class _ResultadoScreenState extends State<ResultadoScreen> {
  final List<String> plataformas = [
    'INPI',
    'Domínio',
    'Maps',
    'Instagram',
    'TikTok',
    'Facebook',
    'YouTube',
  ];


  final Map<String, String> icones = {
    'INPI': 'assets/icons/Asset 7.png',
    'Domínio': 'assets/icons/Asset 6.png',
    'Maps': 'assets/icons/Asset 1.png',
    'Instagram': 'assets/icons/Asset 5.png',
    'TikTok': 'assets/icons/Asset 4.png',
    'Facebook': 'assets/icons/Asset 3.png',
    'YouTube': 'assets/icons/Asset 2.png',
  };

  late Map<String, bool> _estadoLocal;
  late PageController _pageController;
  late List<WebViewController> _controllers;
  final Set<String> _plataformasCorrigidas = {};
  int _paginaAtual = 0;
  final GlobalKey<AvisoINPIState> _avisoKey = GlobalKey<AvisoINPIState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _estadoLocal = Map.from(widget.resultados);
    _controllers = plataformas.map((plataforma) {
      late final WebViewController controller;

      controller = WebViewController();
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..enableZoom(true)
        ..setBackgroundColor(Colors.transparent)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              final url = request.url;
              if (url.startsWith('http') || url.startsWith('https')) {
                return NavigationDecision.navigate;
              } else {
                debugPrint('❌ Esquema desconhecido bloqueado: $url');
                return NavigationDecision.prevent;
              }
            },
            onPageFinished: (url) {
              if (plataforma == 'Maps' && !_plataformasCorrigidas.contains(plataforma)) {
                _plataformasCorrigidas.add(plataforma);
                Future.delayed(const Duration(seconds: 2), () {
                  debugPrint('🔄 Recarregando Maps para corrigir layout (1x apenas)...');
                  controller.reload();
                });
              }

              if (plataforma == 'INPI') {
                _avisoKey.currentState?.ativar();
                injetarScriptINPI(controller, widget.nome);
              }
            },
          ),
        )
        ..addJavaScriptChannel('NotificadorINPI',
          onMessageReceived: (JavaScriptMessage message) {
            if (message.message == 'pesquisa_enviada' || message.message == 'resultado_carregado') {
              _avisoKey.currentState?.resolver();
            }
          },
        )
        ..loadRequest(Uri.parse(_gerarUrl(plataforma, widget.nome)));

      return controller;
    }).toList();
  }

  void _mudarPagina(int index) {
    setState(() {
      _paginaAtual = index;
      _pageController.jumpToPage(index);
    });
  }

  String _slugify(String str) {
    final semAcento = removeDiacritics(str.toLowerCase());
    return semAcento
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  String _gerarUrl(String plataforma, String nome) {
    final slug = _slugify(nome);
    final encoded = Uri.encodeComponent(nome);
    switch (plataforma) {
      case 'INPI':
        return 'http://busca.inpi.gov.br/pePI';
      case 'Domínio':
        return 'https://www.hostinger.com.br/domain-name-results?domain=$slug.com&from=domain-name-search';
      case 'Maps':
        return 'https://www.google.com/maps/search/?api=1&query=$encoded&hl=pt-BR&gl=br';
      case 'Instagram':
        return 'https://www.instagram.com/$slug';
      case 'TikTok':
        return 'https://www.tiktok.com/@$slug';
      case 'Facebook':
        return 'https://www.facebook.com/$slug';
      case 'YouTube':
        return 'https://www.youtube.com/@$slug';
      default:
        return 'https://www.google.com/search?q=$encoded';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: plataformas.map((plataforma) {
                        int index = plataformas.indexOf(plataforma);
                        return GestureDetector(
                          onTap: () => _mudarPagina(index),
                          child: Column(
                            children: [
                              Image.asset(
                                icones[plataforma]!,
                                width: plataforma == 'Maps' ? 22 : 30,
                              ),
                              AnimatedOpacity(
                                opacity: _paginaAtual == index ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.nome} Disponível?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: _estadoLocal[plataformas[_paginaAtual]] ?? false,
                    onChanged: (value) {
                      final plataformaAtual = plataformas[_paginaAtual];
                      setState(() {
                        _estadoLocal[plataformaAtual] = value ?? false;
                      });
                      widget.onResultadoChange(plataformaAtual, value ?? false);
                    },
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) return Colors.blue;
                      return Colors.white;
                    }),
                  ),
                  IconButton(
                    tooltip: 'Recarregar aba',
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      final url = _gerarUrl(plataformas[_paginaAtual], widget.nome);
                      _controllers[_paginaAtual].loadRequest(Uri.parse(url));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Recarregando ${plataformas[_paginaAtual]}...'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _mudarPagina,
                itemCount: plataformas.length,
                itemBuilder: (_, index) {
                  final plataforma = plataformas[index];
                  return Stack(
                    children: [
                      WebViewWidget(
                        controller: _controllers[index],
                        gestureRecognizers: {
                          Factory(() => EagerGestureRecognizer()),
                        },
                      ),
                      if (plataforma == 'INPI') AvisoINPI(key: _avisoKey),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
