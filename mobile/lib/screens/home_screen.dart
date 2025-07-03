// lib/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/nome_card.dart';
import '../widgets/aviso_inpi.dart';
import 'resultado_screen.dart';

class NomeVerificado {
  final String nome;
  bool favorito;
  Map<String, bool> resultados;

  NomeVerificado({
    required this.nome,
    this.favorito = false,
    Map<String, bool>? resultados,
  }) : resultados = resultados ?? {
          'INPI': false,
          'Domínio': false,
          'Maps': false,
          'Instagram': false,
          'TikTok': false,
          'Facebook': false,
          'YouTube': false,
        };

  Map<String, dynamic> toMap() => {
        'nome': nome,
        'favorito': favorito,
        'resultados': resultados,
      };

  factory NomeVerificado.fromMap(Map<String, dynamic> map) => NomeVerificado(
        nome: map['nome'],
        favorito: map['favorito'],
        resultados: Map<String, bool>.from(map['resultados']),
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<NomeVerificado> _historico = [];

@override
void initState() {
  super.initState();
  _carregarHistorico();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    mostrarAvisoINPI(context, this);
  });
}



  Future<void> _salvarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = _historico.map((n) => n.toMap()).toList();
    await prefs.setString('historico', jsonEncode(dados));
  }

  Future<void> _carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString('historico');
    if (dados != null) {
      final List jsonList = jsonDecode(dados);
      setState(() {
        _historico.clear();
        _historico.addAll(jsonList.map((e) => NomeVerificado.fromMap(e)));
      });
    }
  }

  void _adicionarNome() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    final novoNome = NomeVerificado(nome: texto);

    setState(() {
      _historico.removeWhere((n) => n.nome.toLowerCase() == texto.toLowerCase());
      _historico.insert(0, novoNome);
      _controller.clear();
    });

    await _salvarHistorico();

    if (!mounted) return;
    mostrarAvisoINPI(context, this);


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoScreen(
          nome: novoNome.nome,
          resultados: novoNome.resultados,
          onResultadoChange: (plataforma, valor) async {
            setState(() {
              novoNome.resultados[plataforma] = valor;
            });
            await _salvarHistorico();
          },
        ),
      ),
    );
  }

  void _removerNome(NomeVerificado nome) async {
    setState(() {
      _historico.remove(nome);
    });
    await _salvarHistorico();
  }

  void _alternarFavorito(NomeVerificado nome) async {
    setState(() {
      nome.favorito = !nome.favorito;
    });
    await _salvarHistorico();
  }

  void _atualizarResultado(NomeVerificado nome, String plataforma, bool valor) async {
    setState(() {
      nome.resultados[plataforma] = valor;
    });
    await _salvarHistorico();
  }

  void _limparHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _historico.clear();
    });
    await prefs.remove('historico');
  }

  void _mostrarAjuda() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ℹ️ Como usar o Verificador de Nomes'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Digite um nome no campo e clique em "Verificar".'),
              SizedBox(height: 8),
              Text('• O sistema irá checar se o nome está disponível em:'),
              SizedBox(height: 4),
              Text('  - INPI (registro de marca)\n  - Domínio .com\n  - Instagram\n  - TikTok\n  - Facebook\n  - YouTube\n  - Google Maps', style: TextStyle(fontSize: 13)),
              SizedBox(height: 12),
              Text('• Você pode marcar o checkbox caso o nome esteja disponível.'),
              SizedBox(height: 8),
              Text('• Favoritos são marcados com ⭐ e salvos no histórico.'),
              SizedBox(height: 8),
              Text('• Limpe o histórico ao final, se quiser.'),
              SizedBox(height: 8),
              Text('⚠️ Dica: o INPI pode demorar alguns segundos para responder.'),
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: _mostrarAjuda,
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Ajuda'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(height: 120),
                    const Text(
                      'Verificador de Nomes!',
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'cheque a disponibilidade das suas ideias\nde nome antes de passar raiva!',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Digite o nome',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _adicionarNome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Verificar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              const Text('Histórico', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(value: true, onChanged: (v) {}),
                  const Text('O marcado está disponível'),
                ],
              ),
              const Row(
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.star, size: 24, color: Colors.amber),
                  SizedBox(width: 13),
                  Text('Use a estrelinha para favoritar'),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: _historico.map((nome) {
                  return NomeCard(
                    nome: nome.nome,
                    favorito: nome.favorito,
                    resultados: nome.resultados,
                    onExcluir: () => _removerNome(nome),
                    onFavoritoToggle: () => _alternarFavorito(nome),
                    onResultadoChange: (plataforma, valor) => _atualizarResultado(nome, plataforma, valor),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _limparHistorico,
                  icon: const Icon(Icons.cleaning_services, color: Colors.white),
                  label: const Text('Limpar Histórico', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 234, 109, 100)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
