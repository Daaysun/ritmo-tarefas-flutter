import 'package:flutter/material.dart';

import '../servicos/repositorio.dart';
import '../tema.dart';
import '../widgets/botao_gradiente.dart';
import 'tela_calendario.dart';

/// Login e cadastro na mesma tela: o seletor no topo do cartão
/// troca o modo e mostra/esconde os campos extras do cadastro.
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmacao = TextEditingController();

  bool _modoCadastro = false;
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _confirmacao.dispose();
    super.dispose();
  }

  void _trocarModo(bool cadastro) {
    if (cadastro == _modoCadastro) return;
    setState(() {
      _modoCadastro = cadastro;
      _senha.clear();
      _confirmacao.clear();
    });
  }

  void _aviso(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _enviar() {
    FocusScope.of(context).unfocus();
    if (!(_form.currentState?.validate() ?? false)) return;

    final repo = Repositorio.instancia;

    if (_modoCadastro) {
      final erro = repo.cadastrar(_nome.text, _email.text, _senha.text);
      if (erro != null) {
        _aviso(erro);
        return;
      }
      _aviso('Conta criada! Agora é só entrar.');
      _trocarModo(false);
      return;
    }

    final erro = repo.entrar(_email.text, _senha.text);
    if (erro != null) {
      _aviso(erro);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const TelaCalendario()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: _Bolhas()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Marca(),
                      const SizedBox(height: 32),
                      _cartao(),
                      const SizedBox(height: 24),
                      const Text(
                        'Daiany Cristina dos Santos  •  RA 5167452',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Cores.textoApagado,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartao() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Cores.painel,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x22FFFFFF)),
      ),
      child: Form(
        key: _form,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Alternador(cadastro: _modoCadastro, aoTrocar: _trocarModo),
              const SizedBox(height: 20),
              if (_modoCadastro) ...[
                TextFormField(
                  controller: _nome,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'Informe seu nome'
                      : null,
                ),
                const SizedBox(height: 14),
              ],
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: (v) {
                  final email = v?.trim() ?? '';
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _senha,
                obscureText: _ocultarSenha,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _ocultarSenha = !_ocultarSenha),
                    icon: Icon(_ocultarSenha
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                ),
                validator: (v) {
                  final senha = v ?? '';
                  if (senha.isEmpty) return 'Digite a senha';
                  if (_modoCadastro && senha.length < 6) {
                    return 'Use pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              if (_modoCadastro) ...[
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmacao,
                  obscureText: _ocultarSenha,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar senha',
                    prefixIcon: Icon(Icons.lock_reset_rounded),
                  ),
                  validator: (v) =>
                      v != _senha.text ? 'As senhas não conferem' : null,
                ),
              ],
              const SizedBox(height: 24),
              BotaoGradiente(
                texto: _modoCadastro ? 'Criar minha conta' : 'Entrar',
                icone: _modoCadastro
                    ? Icons.person_add_alt_1_rounded
                    : Icons.arrow_forward_rounded,
                aoTocar: _enviar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo inclinado + nome do app.
class _Marca extends StatelessWidget {
  const _Marca();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.rotate(
          angle: -0.12,
          child: Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              gradient: Cores.gradienteQuente,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.checklist_rounded,
              size: 42,
              color: Cores.noite,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Ritmo',
          style: TextStyle(
            fontSize: 44,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: Cores.texto,
          ),
        ),
        const Text(
          'cada dia no seu compasso',
          style: TextStyle(color: Cores.textoApagado, fontSize: 15),
        ),
      ],
    );
  }
}

/// Seletor "Entrar | Criar conta" com a pílula colorida deslizando.
class _Alternador extends StatelessWidget {
  const _Alternador({required this.cadastro, required this.aoTrocar});

  final bool cadastro;
  final ValueChanged<bool> aoTrocar;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Cores.campo,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedAlign(
            alignment:
                cadastro ? Alignment.centerRight : Alignment.centerLeft,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: Cores.gradienteQuente,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Row(
            children: [
              _opcao('Entrar', !cadastro, () => aoTrocar(false)),
              _opcao('Criar conta', cadastro, () => aoTrocar(true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _opcao(String texto, bool ativo, VoidCallback aoTocar) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: aoTocar,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: ativo ? Cores.noite : Cores.textoApagado,
            ),
            child: Text(texto),
          ),
        ),
      ),
    );
  }
}

/// Círculos coloridos e desfocados no fundo da tela de login.
class _Bolhas extends StatelessWidget {
  const _Bolhas();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _bolha(270, const [Color(0x99FF5E7E), Color(0x55FF8A3D)]),
          ),
          Positioned(
            top: 150,
            left: -40,
            child: _bolha(100, const [Color(0x88FFC93C), Color(0x22FFC93C)]),
          ),
          Positioned(
            bottom: -110,
            left: -80,
            child: _bolha(310, const [Color(0x663DA5FF), Color(0x332EE59D)]),
          ),
        ],
      ),
    );
  }

  Widget _bolha(double tamanho, List<Color> cores) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cores,
        ),
      ),
    );
  }
}
