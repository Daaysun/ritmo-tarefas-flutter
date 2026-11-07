import 'package:flutter/material.dart';

import '../tema.dart';

class BotaoGradiente extends StatelessWidget {
  const BotaoGradiente({
    super.key,
    required this.texto,
    required this.aoTocar,
    this.icone,
  });

  final String texto;
  final VoidCallback aoTocar;
  final IconData? icone;

  @override
  Widget build(BuildContext context) {
    final raio = BorderRadius.circular(18);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: Cores.gradienteQuente,
        borderRadius: raio,
        boxShadow: const [
          BoxShadow(
            color: Color(0x66FF5E7E),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: raio,
          onTap: aoTocar,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  texto,
                  style: const TextStyle(
                    color: Cores.noite,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (icone != null) ...[
                  const SizedBox(width: 8),
                  Icon(icone, color: Cores.noite),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
