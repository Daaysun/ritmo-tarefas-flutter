# Ritmo

App de tarefas diárias feito em Flutter para a ACQA de Desenvolvimento para Dispositivos Móveis (UNIUBE).

Daiany Cristina dos Santos – RA 5167452

## O que o app faz

- Cadastro e login na mesma tela, com validação dos campos
- Calendário mensal; cada dia mostra um ponto amarelo (há pendências) ou verde (tudo concluído)
- Lista de tarefas por dia: pendentes primeiro, concluídas depois, ambas em ordem alfabética
- Nova tarefa por `showDialog`; toda tarefa começa como pendente
- Tocar na tarefa marca/desmarca como concluída; arrastar para o lado ou tocar no X remove (com opção de desfazer)

Os dados ficam em memória enquanto o app está aberto. O Firebase não foi usado, conforme permitido no enunciado.

## Organização

```
lib/
  main.dart
  tema.dart
  modelos/     tarefa.dart, usuario.dart
  servicos/    repositorio.dart
  telas/       tela_login.dart, tela_calendario.dart, tela_tarefas.dart
  util/        datas.dart
  widgets/     botao_gradiente.dart, item_tarefa.dart, dialogo_nova_tarefa.dart
```

## Como rodar

O repositório contém apenas os arquivos `.dart`, como pedido no enunciado. Para executar:

```
flutter create ritmo_tarefas
```

Substitua a pasta `lib` do projeto criado por esta e rode `flutter run` com um emulador Android aberto.
