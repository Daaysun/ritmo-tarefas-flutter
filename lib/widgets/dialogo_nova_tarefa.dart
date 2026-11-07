import 'package:flutter/material.dart';

import '../tema.dart';

/// Diálogo aberto com showDialog. Devolve o texto digitado pelo
/// Navigator.pop, ou null se o usuário cancelar.
class DialogoNovaTarefa extends StatefulWidget {
  const DialogoNovaTarefa({super.key});

  @override
  State<DialogoNovaTarefa> createState() => _DialogoNovaTarefaState();
}

class _DialogoNovaTarefaState extends State<DialogoNovaTarefa> {
  final _controle = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  void _salvar() {
    final texto = _controle.text.trim();
    if (texto.isEmpty) {
      setState(() => _erro = 'Escreva o nome da tarefa');
      return;
    }
    Navigator.of(context).pop(texto);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Cores.painel,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: Cores.gradienteQuente,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.edit_note_rounded, color: Cores.noite),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nova tarefa',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Cores.texto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controle,
              autofocus: true,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _salvar(),
              onChanged: (_) {
                if (_erro != null) setState(() => _erro = null);
              },
              decoration: InputDecoration(
                hintText: 'Ex.: Estudar para a prova',
                errorText: _erro,
              ),
            ),
            const Text(
              'Ela entra como pendente; depois é só tocar nela para concluir.',
              style: TextStyle(color: Cores.textoApagado, fontSize: 12),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Cores.textoApagado),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _salvar,
                  style: FilledButton.styleFrom(
                    backgroundColor: Cores.amarelo,
                    foregroundColor: Cores.noite,
                  ),
                  child: const Text(
                    'Adicionar',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
