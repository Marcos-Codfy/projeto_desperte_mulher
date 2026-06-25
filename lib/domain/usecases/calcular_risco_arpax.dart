// Motor principal do cálculo AR PAX.
//
// Executa os 5 passos da metodologia:
//   1. Conta opções POSITIVAS marcadas e soma em cada critério alimentado.
//   2. Converte contagem por critério em nível Likert (1-5) via tabela.
//   3. Aplica os pesos (1/3, 1/2, 1/4 / 1, 1/3, 1/2) e calcula V_final e A_final.
//   4. Classifica V_final em NivelVulnerabilidade e A_final em NivelAmeaca.
//   5. Cruza na matriz 5×5 para chegar ao GrauRisco final.
//
// Características importantes:
//   - É puro Dart (sem dependência de Flutter) → testável em milissegundos.
//   - É determinístico: mesmo input sempre dá o mesmo output.
//   - Aceita respostas parciais (útil para o medidor em tempo real).

import '../entities/criterio_arpax.dart';
import '../entities/grau_risco.dart';
import '../entities/nivel_dimensao.dart';
import '../entities/pergunta.dart';
import '../entities/resposta_usuaria.dart';
import '../entities/resultado_arpax.dart';
import 'cruzar_matriz_risco.dart';

/// Caso de uso: calcular o resultado AR PAX a partir das respostas da usuária.
///
/// Encapsular como classe (em vez de função top-level) permite injeção e
/// substituição por uma versão mockada em testes do controller.
class CalcularRiscoArpax {
  const CalcularRiscoArpax();

  /// Recebe o mapa de respostas e o mapa de perguntas indexado por id,
  /// devolve o ResultadoArpax completo (parcial se nem todas as respostas
  /// estiverem presentes — não vai dar erro, só vai pesar 0 onde faltar).
  ResultadoArpax calcular({
    required Map<String, RespostaUsuaria> respostas,
    required Map<String, Pergunta> perguntas,
  }) {
    // ── Passo 1: contar marcações positivas por critério ───────────────
    final marcacoesPorCriterio = <CriterioArpax, int>{
      for (final c in CriterioArpax.values) c: 0,
    };

    for (final resposta in respostas.values) {
      final pergunta = perguntas[resposta.idPergunta];
      if (pergunta == null) continue;

      final positivas = resposta.contarPositivas(pergunta);
      if (positivas == 0) continue;

      // Cada critério alimentado pela pergunta ganha N pontos,
      // onde N = número de opções positivas marcadas naquela pergunta.
      for (final criterio in pergunta.criteriosAlimentados) {
        marcacoesPorCriterio[criterio] =
            (marcacoesPorCriterio[criterio] ?? 0) + positivas;
      }
    }

    // ── Passo 2: classificar marcações em nível Likert (1-5) ───────────
    // Cada critério usa sua própria tabela (porque o número máximo de
    // marcações possíveis varia). A regra de saturação já está embutida
    // dentro de `classificarLikert`.
    final niveisPorCriterio = <CriterioArpax, int>{};
    for (final entry in marcacoesPorCriterio.entries) {
      niveisPorCriterio[entry.key] = entry.key.classificarLikert(entry.value);
    }

    // ── Passo 3: aplicar pesos → V_final e A_final ─────────────────────
    double vFinal = 0;
    double aFinal = 0;
    for (final criterio in CriterioArpax.values) {
      final nivel = niveisPorCriterio[criterio] ?? 0;
      final contribuicao = nivel * criterio.peso;

      if (criterio.dimensao == Dimensao.vulnerabilidade) {
        vFinal += contribuicao;
      } else {
        aFinal += contribuicao;
      }
    }

    // ── Passo 4: categorizar V_final e A_final em níveis Likert ────────
    final nivelV = NivelVulnerabilidade.fromValor(vFinal);
    final nivelA = NivelAmeaca.fromValor(aFinal);

    // ── Passo 5: cruzar na matriz 5×5 → grau final ─────────────────────
    final GrauRisco grauFinal = cruzarMatriz(nivelV, nivelA);

    return ResultadoArpax(
      marcacoesPorCriterio: marcacoesPorCriterio,
      niveisPorCriterio: niveisPorCriterio,
      vulnerabilidadeFinal: vFinal,
      ameacaFinal: aFinal,
      nivelVulnerabilidade: nivelV,
      nivelAmeaca: nivelA,
      grauFinal: grauFinal,
    );
  }
}
