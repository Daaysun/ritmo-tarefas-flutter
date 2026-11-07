import '../modelos/tarefa.dart';
import '../modelos/usuario.dart';
import '../util/datas.dart';

/// Guarda usuários e tarefas em memória enquanto o app está aberto.
/// Como o enunciado dispensa o Firebase, um único objeto (singleton)
/// faz o papel de "banco de dados" para todas as telas.
class Repositorio {
  Repositorio._();
  static final Repositorio instancia = Repositorio._();

  final Map<String, Usuario> _usuarios = {};

  // e-mail do usuário -> (dia "aaaa-mm-dd" -> tarefas daquele dia)
  final Map<String, Map<String, List<Tarefa>>> _tarefas = {};

  Usuario? _logado;
  Usuario? get usuarioLogado => _logado;

  // ---------- conta ----------

  /// Devolve uma mensagem de erro, ou null se deu certo.
  String? cadastrar(String nome, String email, String senha) {
    final chave = email.trim().toLowerCase();
    if (_usuarios.containsKey(chave)) {
      return 'Já existe uma conta com esse e-mail.';
    }
    _usuarios[chave] = Usuario(nome: nome.trim(), email: chave, senha: senha);
    return null;
  }

  String? entrar(String email, String senha) {
    final usuario = _usuarios[email.trim().toLowerCase()];
    if (usuario == null) return 'E-mail não cadastrado. Crie sua conta primeiro.';
    if (usuario.senha != senha) return 'Senha incorreta.';
    _logado = usuario;
    return null;
  }

  void sair() => _logado = null;

  // ---------- tarefas ----------

  List<Tarefa> _consultar(DateTime dia) =>
      _tarefas[_logado?.email]?[Datas.chave(dia)] ?? const [];

  List<Tarefa> _listaDoDia(DateTime dia) {
    final porDia = _tarefas.putIfAbsent(_logado?.email ?? '', () => {});
    return porDia.putIfAbsent(Datas.chave(dia), () => []);
  }

  /// Pendentes primeiro, depois concluídas; cada grupo em ordem alfabética.
  List<Tarefa> tarefasDoDia(DateTime dia) {
    final lista = List<Tarefa>.of(_consultar(dia));
    lista.sort(_comparar);
    return lista;
  }

  void adicionar(DateTime dia, String titulo) =>
      _listaDoDia(dia).add(Tarefa(titulo: titulo.trim()));

  /// Usado pelo "Desfazer" depois de uma remoção.
  void inserir(DateTime dia, Tarefa tarefa) => _listaDoDia(dia).add(tarefa);

  void remover(DateTime dia, Tarefa tarefa) => _listaDoDia(dia).remove(tarefa);

  void alternar(Tarefa tarefa) => tarefa.concluida = !tarefa.concluida;

  int pendentes(DateTime dia) =>
      _consultar(dia).where((t) => !t.concluida).length;

  int concluidas(DateTime dia) =>
      _consultar(dia).where((t) => t.concluida).length;

  static int _comparar(Tarefa a, Tarefa b) {
    if (a.concluida != b.concluida) return a.concluida ? 1 : -1;
    return _semAcento(a.titulo).compareTo(_semAcento(b.titulo));
  }

  // Sem isso, "Água" iria parar depois de "Zebra" na ordenação.
  static String _semAcento(String texto) {
    const com = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const sem = 'aaaaaeeeeiiiiooooouuuuc';
    final buffer = StringBuffer();
    for (final letra in texto.toLowerCase().split('')) {
      final i = com.indexOf(letra);
      buffer.write(i >= 0 ? sem[i] : letra);
    }
    return buffer.toString();
  }
}
