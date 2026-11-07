import 'package:flutter/material.dart';

import '../modelos/tarefa.dart';
import '../tema.dart';

/// Um item da lista. Tocar marca/desmarca; arrastar para a esquerda
/// (ou tocar no X) remove.
class ItemTarefa extends StatelessWidget {
  const ItemTarefa({
    super.key,
    required this.tarefa,
    required this.aoAlternar,
    required this.aoRemover,
  });

  final Tarefa tarefa;
  final VoidCallback aoAlternar;
  final VoidCallback aoRemover;

  @override
  Widget build(BuildContext context) {
    final feita = tarefa.concluida;
    final raio = BorderRadius.circular(20);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ObjectKey(tarefa),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => aoRemover(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(color: Cores.coral, borderRadius: raio),
          child: const Icon(Icons.delete_outline_rounded, color: Cores.noite),
        ),
        child: Material(
          color: Cores.painel,
          borderRadius: raio,
          child: InkWell(
            borderRadius: raio,
            onTap: aoAlternar,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 6, 8),
              child: Row(
                children: [
                  _Marcador(feita: feita),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      tarefa.titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: feita ? Cores.textoApagado : Cores.texto,
                        decoration: feita ? TextDecoration.lineThrough : null,
                        decorationColor: Cores.menta,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Remover',
                    onPressed: aoRemover,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Cores.textoApagado,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Marcador extends StatelessWidget {
  const _Marcador({required this.feita});

  final bool feita;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: feita ? Cores.menta : Colors.transparent,
        border: Border.all(
          color: feita ? Cores.menta : Cores.amarelo,
          width: 2.5,
        ),
      ),
      child: feita
          ? const Icon(Icons.check_rounded, size: 18, color: Cores.noite)
          : null,
    );
  }
}
