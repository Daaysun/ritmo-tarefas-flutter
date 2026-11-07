class Usuario {
  const Usuario({
    required this.nome,
    required this.email,
    required this.senha,
  });

  final String nome;
  final String email;
  final String senha;

  String get primeiroNome => nome.trim().split(' ').first;
}
