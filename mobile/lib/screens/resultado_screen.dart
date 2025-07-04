import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:diacritic/diacritic.dart';
import 'package:mobile/inpi_script.dart';
import 'package:mobile/widgets/aviso_inpi.dart';

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

  late PageController _pageController;
  late List<WebViewController> _controllers;
  final Set<String> _plataformasCorrigidas = {};
  // ignore: prefer_final_fields
  final Set<String> _plataformasCorrigidas = {};
  // ignore: prefer_final_fields
  int _paginaAtual = 0;

  final GlobalKey<AvisoINPIState> _avisoKey = GlobalKey<AvisoINPIState>();


 

  final GlobalKey<AvisoINPIState> _avisoKey = GlobalKey<AvisoINPIState>();


 

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _controllers = plataformas.map((plataforma) {
      late final WebViewController controller;
      controller = WebViewController()
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
    _controllers = plataformas.map((plataforma) {
      late final WebViewController controller;
      controller = WebViewController()
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
              if (plataforma == 'INPI') {
                _avisoKey.currentState?.ativar();
                injetarScriptINPI(controller, widget.nome);
              }

            },
          ),
        )
        ..loadRequest(Uri.parse(_gerarUrl(plataforma, widget.nome)));
            },
          ),
        )
        ..loadRequest(Uri.parse(_gerarUrl(plataforma, widget.nome)));

        controller.addJavaScriptChannel('NotificadorINPI',
          onMessageReceived: (JavaScriptMessage message) {
            if (message.message == 'pesquisa_enviada' || message.message == 'resultado_carregado') {
              _avisoKey.currentState?.resolver();
            }
          },
        );
        controller.addJavaScriptChannel('NotificadorINPI',
          onMessageReceived: (JavaScriptMessage message) {
            if (message.message == 'pesquisa_enviada' || message.message == 'resultado_carregado') {
              _avisoKey.currentState?.resolver();
            }
          },
        );


      return controller;
      return controller;
    }).toList();
  }

  void reverificarAtual() {
    final plataforma = plataformas[_paginaAtual];
    final url = _gerarUrl(plataforma, widget.nome);
    _controllers[_paginaAtual].loadRequest(Uri.parse(url));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔄 Verificando novamente $plataforma...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mudarPagina(int index) {
    _pageController.jumpToPage(index);
  }
  void _mudarPagina(int index) {
    _pageController.jumpToPage(index);
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
                                width: plataforma == 'Maps' ? 22 : 30,
                              ),
                              if (_paginaAtual == index)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
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
                  Checkbox(
                    value: widget.resultados[plataformas[_paginaAtual]] ?? false,
                    onChanged: (valor) {
                      setState(() {
                        widget.onResultadoChange(plataformas[_paginaAtual], valor ?? false);
                      });
                    },
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
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
                onPageChanged: (index) {
                  setState(() {
                    _paginaAtual = index;
                  });
                },

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
                        if (plataforma == 'INPI')
                          AvisoINPI(key: _avisoKey),
                      ],
                    );
                  }

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
                        if (plataforma == 'INPI')
                          AvisoINPI(key: _avisoKey),
                      ],
                    );
                  }

              ),
            ),
          ],
        ),
      ),
    );
  }
}
