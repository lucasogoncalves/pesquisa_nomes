// lib/screens/editar_card_screen.dart
import 'package:flutter/material.dart';

class EditarCardScreen extends StatelessWidget {
  const EditarCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Card')),
      body: Center(child: Text('Edição de Card')),
    );
  }
}
