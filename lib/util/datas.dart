/// Funções de data em português, sem depender do pacote intl.
class Datas {
  static const meses = [
    'janeiro', 'fevereiro', 'março', 'abril', 'maio', 'junho',
    'julho', 'agosto', 'setembro', 'outubro', 'novembro', 'dezembro',
  ];

  // Índice 0 = domingo (DateTime.weekday devolve 7 para domingo, por isso o % 7)
  static const diasSemana = [
    'domingo', 'segunda-feira', 'terça-feira', 'quarta-feira',
    'quinta-feira', 'sexta-feira', 'sábado',
  ];

  static const iniciais = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  static String _doisDigitos(int n) => n.toString().padLeft(2, '0');

  /// Chave usada para guardar as tarefas de cada dia (ex.: 2026-11-07).
  static String chave(DateTime d) =>
      '${d.year}-${_doisDigitos(d.month)}-${_doisDigitos(d.day)}';

  static bool mesmoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String nomeMes(int mes) => meses[mes - 1];

  static String diaDaSemana(DateTime d) => diasSemana[d.weekday % 7];

  static String curta(DateTime d) =>
      '${_doisDigitos(d.day)}/${_doisDigitos(d.month)}/${d.year}';

  static String capitalizar(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
