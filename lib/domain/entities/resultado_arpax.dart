// O resultado completo do cálculo AR PAX.
//
// Carrega não só o "grau final" que aparece na tela de Resultado,
// mas também todos os passos intermediários — útil para:
//   1. Debug e validação (a planilha do Felipe Scarpelli mostra
//      breakdown por critério; queremos poder reproduzir igualzinho).
//   2. Animar o MedidorRisco em tempo real durante o preenchimento.
//   3. Mostrar opcionalmente o breakdown para profissionais que
//      atendem a usuária depois (rastreabilidade científica).

import 'criterio_arpax.dart';
import 'grau_risco.dart';
import 'nivel_dimensao.dart';

/// Resultado de uma execução do motor AR PAX.
class ResultadoArpax {
  /// Quantas marcações positivas cada critério recebeu.
  /// Inclui todos os 6 critérios — os não acionados ficam com 0.
  final Map<CriterioArpax, int> marcacoesPorCriterio;

  /// Nível Likert (1-5) de cada critério após aplicar a tabela
  /// `classificarLikert`. Critério não acionado fica em 0.
  final Map<CriterioArpax, int> niveisPorCriterio;

  /// V_final = soma de (nível × peso) dos 3 critérios da Vulnerabilidade.
  /// Faixa esperada: 0.00 a ~5.42.
  final double vulnerabilidadeFinal;

  /// A_final = soma de (nível × peso) dos 3 critérios da Ameaça.
  /// Faixa esperada: 0.00 a ~9.17.
  final double ameacaFinal;

  /// Categorização de V_final em nível Likert (Muito Baixa..Muito Alta).
  final NivelVulnerabilidade nivelVulnerabilidade;

  /// Categorização de A_final em nível Likert (Insignificante..Extrema).
  final NivelAmeaca nivelAmeaca;

  /// Grau final do cruzamento na matriz 5×5 — o que a usuária vê.
  final GrauRisco grauFinal;

  const ResultadoArpax({
    required this.marcacoesPorCriterio,
    required this.niveisPorCriterio,
    required this.vulnerabilidadeFinal,
    required this.ameacaFinal,
    required this.nivelVulnerabilidade,
    required this.nivelAmeaca,
    required this.grauFinal,
  });

  /// Resultado "zero" — usado como estado inicial e para respostas vazias.
  factory ResultadoArpax.vazio() {
    final marcacoes = <CriterioArpax, int>{
      for (final c in CriterioArpax.values) c: 0,
    };
    final niveis = <CriterioArpax, int>{
      for (final c in CriterioArpax.values) c: 0,
    };
    return ResultadoArpax(
      marcacoesPorCriterio: marcacoes,
      niveisPorCriterio: niveis,
      vulnerabilidadeFinal: 0,
      ameacaFinal: 0,
      nivelVulnerabilidade: NivelVulnerabilidade.muitoBaixa,
      nivelAmeaca: NivelAmeaca.insignificante,
      grauFinal: GrauRisco.muitoBaixo,
    );
  }
}
