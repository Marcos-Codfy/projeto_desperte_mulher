// Contrato da fonte de perguntas do quiz.
//
// Fica em domain/ porque a regra é: domínio depende só de si mesmo.
// A implementação concreta (lendo JSON local na fase atual, lendo da
// API Django no futuro) mora em data/.

import '../entities/pergunta.dart';

/// Resultado da consulta a uma etapa: o título da etapa e a lista de
/// perguntas. Mantemos esse pequeno wrapper porque o título e o subtítulo
/// da etapa também vêm do JSON e aparecem no header da AvaliacaoPage.
class EtapaQuiz {
  final int numero;
  final int totalEtapas;
  final String titulo;
  final String subtitulo;
  final List<Pergunta> perguntas;

  const EtapaQuiz({
    required this.numero,
    required this.totalEtapas,
    required this.titulo,
    required this.subtitulo,
    required this.perguntas,
  });
}

/// Fonte de perguntas do quiz.
/// Hoje implementada por JSON local; amanhã pode virar HTTP.
abstract class QuizRepository {
  /// Carrega a etapa N (1..5) com suas perguntas.
  Future<EtapaQuiz> carregarEtapa(int numeroEtapa);

  /// Carrega todas as 5 etapas concatenadas — útil para o cálculo final
  /// ter um único `Map<String, Pergunta>` por id.
  Future<List<EtapaQuiz>> carregarTodas();
}
