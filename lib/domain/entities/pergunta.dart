// Uma pergunta do FONAR (Formulário Nacional de Avaliação de Risco).
//
// O texto de cada pergunta é regulamentado pela Resolução Conjunta nº 5/2020
// do CNJ e CNMP — não pode ser alterado.
//
// O que MUDA entre perguntas: o `modo` (escolha única vs múltipla) e
// `criteriosAlimentados` (quais dos 6 critérios AR PAX recebem pontos
// quando a usuária marca opções positivas).

import 'criterio_arpax.dart';
import 'opcao_resposta.dart';

/// Define se a pergunta aceita uma só opção marcada (radio) ou várias (checkbox).
enum ModoSelecao { unica, multipla }

/// Uma pergunta do FONAR com suas opções e o mapeamento de critérios
/// que ela alimenta na metodologia AR PAX.
class Pergunta {
  /// Identificador interno (ex: "P1", "P7a", "P16b").
  final String id;

  /// Número visível na UI (ex: "1", "7.a", "16.b").
  final String numero;

  /// Enunciado literal da pergunta (não alterar — regulamentação).
  final String texto;

  /// Texto opcional de apoio mostrado abaixo do enunciado.
  /// É AQUI que entra o microcopy acolhedor que envolve a pergunta
  /// (ex: "Sabemos que esta é uma pergunta difícil. Responda no seu tempo.").
  final String? textoApoio;

  /// Se a pergunta aceita escolha única ou múltipla.
  final ModoSelecao modo;

  /// Lista de opções de resposta na ordem em que aparecem na UI.
  final List<OpcaoResposta> opcoes;

  /// Conjunto dos critérios AR PAX que esta pergunta alimenta.
  /// Cada opção positiva marcada soma 1 ponto em CADA critério desta lista.
  ///
  /// Exemplo: Pergunta 21 alimenta {VC2, VC3, AC1, AC2, AC3} — se a
  /// resposta for "Sim", todos os 5 contadores ganham 1.
  final Set<CriterioArpax> criteriosAlimentados;

  /// Sinaliza que a pergunta carrega peso emocional alto e merece
  /// cuidado visual extra na UI (borda mais grossa, padding maior,
  /// texto de apoio em destaque).
  ///
  /// Não muda nada no cálculo — é puramente uma marca para o presenter.
  /// Exemplo: P4 (relações sexuais forçadas).
  final bool sensivel;

  const Pergunta({
    required this.id,
    required this.numero,
    required this.texto,
    required this.modo,
    required this.opcoes,
    required this.criteriosAlimentados,
    this.textoApoio,
    this.sensivel = false,
  });
}
