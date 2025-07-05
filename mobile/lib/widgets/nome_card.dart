import 'package:flutter/material.dart';
import 'package:verificadordenomes/screens/resultado_screen.dart';

class NomeCard extends StatelessWidget {
  final String nome;
  final bool favorito;
  final VoidCallback onExcluir;
  final VoidCallback onFavoritoToggle;
  final Map<String, bool> resultados;
  final void Function(String plataforma, bool novoValor) onResultadoChange;

  const NomeCard({
    super.key,
    required this.nome,
    required this.favorito,
    required this.onExcluir,
    required this.onFavoritoToggle,
    required this.resultados,
    required this.onResultadoChange,
  });

  @override
  Widget build(BuildContext context) {
    final plataformaImagens = {
      'INPI': 'assets/icons/Asset 7.png',
      'Domínio': 'assets/icons/Asset 6.png',
      'Maps': 'assets/icons/Asset 1.png',
      'Instagram': 'assets/icons/Asset 5.png',
      'TikTok': 'assets/icons/Asset 4.png',
      'Facebook': 'assets/icons/Asset 3.png',
      'YouTube': 'assets/icons/Asset 2.png',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  favorito ? Icons.star : Icons.star_border,
                  color: favorito ? Colors.amber : Colors.grey,
                ),
                onPressed: onFavoritoToggle,
              ),
              Expanded(
                child: Text(
                  nome,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Reverificar nome',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultadoScreen(
                        nome: nome,
                        resultados: resultados,
                        onResultadoChange: onResultadoChange,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onExcluir,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 2,
            runSpacing: 2,
            alignment: WrapAlignment.center,
            children: plataformaImagens.entries.map((entry) {
              final plataforma = entry.key;
              final icone = entry.value;
              final selecionado = resultados[plataforma] ?? false;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    icone,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(height: 6),
                  Checkbox(
                    value: selecionado,
                    onChanged: null,
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.blue;
                      }
                      return Colors.white;
                    }),
                    checkColor: const Color.fromARGB(255, 255, 255, 255),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
