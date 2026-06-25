// A resposta que a usuária deu a uma pergunta específica.
//
// Modela só os índices das opções marcadas (números) — o texto fica
// na Pergunta. Isso mantém o estado em RAM enxuto e o cálculo rápido.

import 'pergunta.dart';

/// Resposta de uma usuária a uma pergunta — guardada em RAM até ela
/// fechar o navegador.
class RespostaUsuaria {
  /// Id da pergunta a que esta resposta se refere.
  final String idPergunta;

  /// Índices das opções marcadas (0-based).
  /// Em modo `unica`, terá no máximo 1 elemento.
  /// Em modo `multipla`, pode ter de 0 a N elementos.
  final List<int> indicesMarcados;

  const RespostaUsuaria({
    required this.idPergunta,
    required this.indicesMarcados,
  });

  /// Conta quantas opções POSITIVAS estão marcadas.
  ///
  /// "Positiva" = a opção NÃO é negativa (ver OpcaoResposta.ehNegativa).
  /// Resposta "Não", "Não sei", "Nenhuma agressão física" → contam 0.
  ///
  /// Este número é exatamente o que o motor AR PAX soma em cada critério
  /// alimentado pela pergunta.
  int contarPositivas(Pergunta p) {
    var total = 0;
    for (final idx in indicesMarcados) {
      if (idx < 0 || idx >= p.opcoes.length) continue;
      if (!p.opcoes[idx].ehNegativa) total++;
    }
    return total;
  }
}
