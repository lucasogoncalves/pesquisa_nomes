// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/resultado_screen.dart';
import 'screens/editar_card_screen.dart';

void main() {
  runApp(VerificadorApp());
}

class BackgroundColor {
  static const Color primary = Color.fromARGB(255, 255, 255, 255);
}



class VerificadorApp extends StatelessWidget {
  const VerificadorApp({super.key}); // <- aqui está a mágica

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Verificador de Nomes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? Colors.blue
                : Colors.grey;
          }),
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),

      home: const HomeScreen(),
      routes: {
        '/resultado': (_) => ResultadoScreen(
          nome: 'Exemplo',
          resultados: {
            'INPI': false,
            'Domínio': false,
            'Maps': false,
            'Instagram': false,
            'TikTok': false,
            'Facebook': false,
            'YouTube': false,
          },
          onResultadoChange: (plataforma, novoValor) {
            // Exemplo: print('$plataforma -> $novoValor');
          },
        ),

        '/editar': (_) => const EditarCardScreen(),
      },
    );
  }
}
