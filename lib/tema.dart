import 'package:flutter/material.dart';

/// Paleta do app: fundo azul-noite com acentos quentes (coral, laranja,
/// amarelo) e menta para o que já foi concluído.
class Cores {
  static const noite = Color(0xFF14122B);
  static const painel = Color(0xFF221F45);
  static const campo = Color(0xFF2E2A5C);
  static const coral = Color(0xFFFF5E7E);
  static const laranja = Color(0xFFFF8A3D);
  static const amarelo = Color(0xFFFFC93C);
  static const menta = Color(0xFF2EE59D);
  static const azul = Color(0xFF3DA5FF);
  static const texto = Color(0xFFF4F1FF);
  static const textoApagado = Color(0xFF9C97C9);

  static const gradienteQuente = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [coral, laranja, amarelo],
  );
}

class Tema {
  static ThemeData escuro() {
    final borda = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Cores.noite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Cores.coral,
        brightness: Brightness.dark,
        primary: Cores.coral,
        secondary: Cores.amarelo,
        surface: Cores.painel,
      ),
    );

    return base.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Cores.campo,
        labelStyle: const TextStyle(color: Cores.textoApagado),
        hintStyle: const TextStyle(color: Cores.textoApagado),
        prefixIconColor: Cores.textoApagado,
        suffixIconColor: Cores.textoApagado,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: borda,
        enabledBorder: borda,
        focusedBorder: borda.copyWith(
          borderSide: const BorderSide(color: Cores.amarelo, width: 2),
        ),
        errorBorder: borda.copyWith(
          borderSide: const BorderSide(color: Cores.coral, width: 1.5),
        ),
        focusedErrorBorder: borda.copyWith(
          borderSide: const BorderSide(color: Cores.coral, width: 2),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Cores.campo,
        contentTextStyle: TextStyle(color: Cores.texto),
        actionTextColor: Cores.amarelo,
      ),
    );
  }
}
