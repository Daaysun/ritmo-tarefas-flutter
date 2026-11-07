class Tarefa {
  Tarefa({required this.titulo, this.concluida = false});

  final String titulo;

  /// Toda tarefa nasce pendente; o usuário marca como feita depois.
  bool concluida;
}
