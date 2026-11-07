import 'package:flutter/material.dart';

import 'tema.dart';
import 'telas/tela_login.dart';

void main() {
  runApp(const RitmoApp());
}

class RitmoApp extends StatelessWidget {
  const RitmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ritmo',
      debugShowCheckedModeBanner: false,
      theme: Tema.escuro(),
      home: const TelaLogin(),
    );
  }
}
