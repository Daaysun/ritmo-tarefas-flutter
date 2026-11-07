import 'package:flutter/material.dart';

import '../modelos/tarefa.dart';
import '../servicos/repositorio.dart';
import '../tema.dart';
import '../util/datas.dart';
import '../widgets/dialogo_nova_tarefa.dart';
import '../widgets/item_tarefa.dart';

/// Lista de tarefas de um dia. A ordem (pendentes primeiro, depois
/// concluídas, ambas em ordem alfabética) vem pronta do Repositorio.
class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key, required this.dia});

  final DateTime dia;

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final _repo = Repositorio.instancia;

  Future<void> _novaTarefa() async {
    final titulo = await showDialog<String>(
      context: context,
      builder: (_) => const DialogoNovaTarefa(),
    );
    if (titulo == null || titulo.trim().isEmpty) return;
    setState(() => _repo.adicionar(widget.dia, titulo));
  }

  void _alternar(Tarefa tarefa) {
    setState(() => _repo.alternar(tarefa));
  }

  void _remover(Tarefa tarefa) {
    setState(() => _repo.remover(widget.dia, tarefa));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${tarefa.titulo}" removida'),
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              if (!mounted) return;
              setState(() => _repo.inserir(widget.dia, tarefa));
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tarefas = _repo.tarefasDoDia(widget.dia);
    final pendentes = tarefas.where((t) => !t.concluida).toList();
    final concluidas = tarefas.where((t) => t.concluida).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _novaTarefa,
        backgroundColor: Cores.amarelo,
        foregroundColor: Cores.noite,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Cabecalho(
              dia: widget.dia,
              total: tarefas.length,
              feitas: concluidas.length,
            ),
            Expanded(
              child: tarefas.isEmpty
                  ? const _DiaLivre()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
                      children: [
                        if (pendentes.isNotEmpty) ...[
                          _TituloSecao(
                            titulo: 'Pendentes',
                            quantidade: pendentes.length,
                            cor: Cores.amarelo,
                          ),
                          ...pendentes.map(_item),
                        ],
                        if (concluidas.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _TituloSecao(
                            titulo: 'Concluídas',
                            quantidade: concluidas.length,
                            cor: Cores.menta,
                          ),
                          ...concluidas.map(_item),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(Tarefa tarefa) {
    return ItemTarefa(
      key: ObjectKey(tarefa),
      tarefa: tarefa,
      aoAlternar: () => _alternar(tarefa),
      aoRemover: () => _remover(tarefa),
    );
  }
}

/// Cartão colorido no topo com o dia e a barra de progresso.
class _Cabecalho extends StatelessWidget {
  const _Cabecalho({
    required this.dia,
    required this.total,
    required this.feitas,
  });

  final DateTime dia;
  final int total;
  final int feitas;

  @override
  Widget build(BuildContext context) {
    final progresso = total == 0 ? 0.0 : feitas / total;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 20),
      decoration: BoxDecoration(
        gradient: Cores.gradienteQuente,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded, color: Cores.noite),
              ),
              const Spacer(),
              Text(
                Datas.curta(dia),
                style: const TextStyle(
                  color: Cores.noite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${dia.day}',
                      style: const TextStyle(
                        color: Cores.noite,
                        fontSize: 64,
                        height: 0.95,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Datas.capitalizar(Datas.diaDaSemana(dia)),
                            style: const TextStyle(
                              color: Cores.noite,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${Datas.nomeMes(dia.month)} de ${dia.year}',
                            style: const TextStyle(color: Color(0xCC14122B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: progresso),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    builder: (_, valor, __) => LinearProgressIndicator(
                      value: valor,
                      minHeight: 10,
                      backgroundColor: const Color(0x3314122B),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Cores.noite),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  total == 0
                      ? 'Nenhuma tarefa ainda'
                      : '$feitas de $total concluídas',
                  style: const TextStyle(
                    color: Cores.noite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  const _TituloSecao({
    required this.titulo,
    required this.quantidade,
    required this.cor,
  });

  final String titulo;
  final int quantidade;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 10, left: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            titulo.toUpperCase(),
            style: const TextStyle(
              color: Cores.textoApagado,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Cores.campo,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$quantidade',
              style: TextStyle(
                color: cor,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiaLivre extends StatelessWidget {
  const _DiaLivre();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wb_sunny_rounded, size: 64, color: Cores.amarelo),
            SizedBox(height: 12),
            Text(
              'Dia livre por enquanto',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Cores.texto,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Toque em "Nova tarefa" para começar.',
              style: TextStyle(color: Cores.textoApagado),
            ),
          ],
        ),
      ),
    );
  }
}
