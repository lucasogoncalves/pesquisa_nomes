import 'package:flutter/material.dart';

void mostrarDialogAjuda(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('ℹ️ Como usar o Verificador de Nomes'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Digite o nome, depois toque em "Verificar".'),
            SizedBox(height: 8),
            Text('• O app vai usar o nome pra agilizar a pesquisa e você poderá checar a disponibilidade na tela de resultados clicando nas abas:'),
             SizedBox(height: 10),
             Text(
              '  - INPI (Registro de marca)\n  - Hostinger (Domínio)\n  - Google Maps (no Brasil todo)\n  - Instagram\n  - TikTok\n  - Facebook\n  - YouTube',
              style: TextStyle(fontSize: 13),
            ),
             SizedBox(height: 10),
            Text('• Em cada aba, você pode olhar a plataforma e marcar a caixinha de seleção se o nome NÃO estiver sendo usado, ou seja disponível pra você usar. isso vai ficar salvo no histórico'),
            SizedBox(height: 8),
            Text('se precisar, o botão de recarregar reabre a página da plataforma selecionanda na aba'),
            SizedBox(height: 8),
            Text('• você pode usar a ⭐ pra identificar os seus nomes favoritos (tanto na tela de resultados quanto no histórico)'),
            SizedBox(height: 8),
            Text('No histórico o botão de recarregar serve para refazer sua pesquisa, e o botão de apagar (X) para remover o nome do histórico.'),
            SizedBox(height: 8),
            Text('• Limpe o histórico no final, se quiser.'),
            SizedBox(height: 8),
            Text('⚠️ Dica 1: o INPI pode demorar alguns segundos para responder.'),
            Text('⚠️ Dica 2: As redes sociais funcionam melhor se você fizer login quando solicitado no primeiro uso'),
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
