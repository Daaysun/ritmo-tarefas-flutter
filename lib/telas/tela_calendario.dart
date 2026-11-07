import 'package:flutter/material.dart';

import '../servicos/repositorio.dart';
import '../tema.dart';
import '../util/datas.dart';
import '../widgets/botao_gradiente.dart';
import 'tela_login.dart';
import 'tela_tarefas.dart';

/// Calendário do mês montado à mão (GridView de 7 colunas).
/// Cada dia mostra um pontinho: amarelo se ainda há tarefa pendente,
/// verde se tudo daquele dia já foi concluído.
class TelaCalendario extends StatefulWidget {
  const TelaCalendario({super.key});

  @override
  State<TelaCalendario> createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  final _repo = Repositorio.instancia;

  late DateTime _mesVisivel;
  late DateTime _selecionado;

  @override
  void initState() {
    super.initState();
    final hoje = DateTime.now();
    _selecionado = DateTime(hoje.year, hoje.month, hoje.day);
    _mesVisivel = DateTime(hoje.year, hoje.month);
  }

  // DateTime ajusta sozinho: mês 13 vira janeiro do ano seguinte, mês 0 vira dezembro.
  void _mudarMes(int delta) {
    setState(() {
      _mesVisivel = DateTime(_mesVisivel.year, _mesVisivel.month + delta);
    });
  }

  Future<void> _abrirDia() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TelaTarefas(dia: _selecionado)),
    );
    // Volta da lista: atualiza os pontinhos e o resumo.
    if (mounted) setState(() {});
  }

  void _sair() {
    _repo.sair();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TelaLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nome = _repo.usuarioLogado?.primeiroNome ?? 'visitante';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, $nome',
                        style: const TextStyle(
                          color: Cores.textoApagado,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Escolha o dia',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: Cores.texto,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _sair,
                  tooltip: 'Sair',
                  icon: const Icon(Icons.logout_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _cartaoMes(),
            const SizedBox(height: 20),
            _resumoDoDia(),
          ],
        ),
      ),
    );
  }

  Widget _cartaoMes() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
      decoration: BoxDecoration(
        color: Cores.painel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => _mudarMes(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      Datas.capitalizar(Datas.nomeMes(_mesVisivel.month)),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Cores.texto,
                      ),
                    ),
                    Text(
                      '${_mesVisivel.year}',
                      style: const TextStyle(color: Cores.textoApagado),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _mudarMes(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Center(
                    child: Text(
                      Datas.iniciais[i],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: i == 0 ? Cores.coral : Cores.textoApagado,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            child: _gradeDias(),
          ),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legenda(cor: Cores.amarelo, texto: 'pendente'),
              SizedBox(width: 16),
              _Legenda(cor: Cores.menta, texto: 'tudo feito'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gradeDias() {
    final ano = _mesVisivel.year;
    final mes = _mesVisivel.month;
    final vazios = DateTime(ano, mes, 1).weekday % 7; // domingo = coluna 0
    final totalDias = DateTime(ano, mes + 1, 0).day;  // dia 0 do mês seguinte = último dia deste
    final hoje = DateTime.now();

    return GridView.builder(
      key: ValueKey('$ano-$mes'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: vazios + totalDias,
      itemBuilder: (context, i) {
        if (i < vazios) return const SizedBox.shrink();
        final dia = DateTime(ano, mes, i - vazios + 1);
        return _CelulaDia(
          dia: dia,
          selecionado: Datas.mesmoDia(dia, _selecionado),
          hoje: Datas.mesmoDia(dia, hoje),
          pendentes: _repo.pendentes(dia),
          concluidas: _repo.concluidas(dia),
          aoTocar: () => setState(() => _selecionado = dia),
        );
      },
    );
  }

  Widget _resumoDoDia() {
    final pend = _repo.pendentes(_selecionado);
    final feitas = _repo.concluidas(_selecionado);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E2A6B), Color(0xFF1C1940)],
        ),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Datas.capitalizar(Datas.diaDaSemana(_selecionado)),
            style: const TextStyle(
              color: Cores.coral,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            '${_selecionado.day} de ${Datas.nomeMes(_selecionado.month)}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Cores.texto,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Contador(
                  valor: pend,
                  rotulo: 'pendentes',
                  cor: Cores.amarelo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Contador(
                  valor: feitas,
                  rotulo: 'concluídas',
                  cor: Cores.menta,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: BotaoGradiente(
              texto: 'Ver tarefas do dia',
              icone: Icons.arrow_forward_rounded,
              aoTocar: _abrirDia,
            ),
          ),
        ],
      ),
    );
  }
}

class _CelulaDia extends StatelessWidget {
  const _CelulaDia({
    required this.dia,
    required this.selecionado,
    required this.hoje,
    required this.pendentes,
    required this.concluidas,
    required this.aoTocar,
  });

  final DateTime dia;
  final bool selecionado;
  final bool hoje;
  final int pendentes;
  final int concluidas;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final temTarefa = pendentes + concluidas > 0;
    final corPonto = pendentes > 0 ? Cores.amarelo : Cores.menta;
    final domingo = dia.weekday == DateTime.sunday;

    Color corNumero = domingo ? Cores.coral : Cores.texto;
    if (selecionado) corNumero = Cores.noite;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: aoTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          gradient: selecionado ? Cores.gradienteQuente : null,
          color: selecionado
              ? null
              : (hoje ? Cores.campo : Colors.transparent),
          borderRadius: BorderRadius.circular(14),
          border: (hoje && !selecionado)
              ? Border.all(color: Cores.amarelo, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${dia.day}',
              style: TextStyle(
                color: corNumero,
                fontWeight: (selecionado || hoje)
                    ? FontWeight.w800
                    : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !temTarefa
                    ? Colors.transparent
                    : (selecionado ? Cores.noite : corPonto),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  const _Contador({
    required this.valor,
    required this.rotulo,
    required this.cor,
  });

  final int valor;
  final String rotulo;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Cores.campo,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Text(
            '$valor',
            style: TextStyle(
              color: cor,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              rotulo,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Cores.textoApagado),
            ),
          ),
        ],
      ),
    );
  }
}

class _Legenda extends StatelessWidget {
  const _Legenda({required this.cor, required this.texto});

  final Color cor;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          texto,
          style: const TextStyle(color: Cores.textoApagado, fontSize: 12),
        ),
      ],
    );
  }
}
