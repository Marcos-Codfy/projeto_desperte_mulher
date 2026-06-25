// Uma opção de resposta dentro de uma pergunta do FONAR.
//
// O texto é literal — não pode ser alterado (regulamentação CNJ/CNMP).
// A flag `ehNegativa` é o que separa "respondi 'Não'" de "respondi 'Sim'"
// dentro do motor: opções negativas não somam pontos para nenhum critério.

/// Uma das alternativas que a usuária pode marcar em uma pergunta.
class OpcaoResposta {
  /// Texto literal da opção (vem do FONAR — não alterar).
  final String texto;

  /// Se esta opção, quando marcada, NÃO deve somar pontos para os
  /// critérios alimentados pela pergunta.
  ///
  /// Exemplos típicos: "Não", "Não sei", "Nenhuma agressão física".
  /// Existem porque o FONAR exige que a opção esteja na lista, mas
  /// elas representam ausência do fator de risco — não soma nada.
  final bool ehNegativa;

  /// Se a opção exige input adicional do usuário (ex: "Outra. Especificar: __").
  /// No motor de cálculo isso é irrelevante (continua valendo 1 ponto se
  /// marcada e não-negativa); fica aqui como hint para a UI.
  final bool requerInputAdicional;

  const OpcaoResposta({
    required this.texto,
    this.ehNegativa = false,
    this.requerInputAdicional = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpcaoResposta &&
        other.texto == texto &&
        other.ehNegativa == ehNegativa &&
        other.requerInputAdicional == requerInputAdicional;
  }

  @override
  int get hashCode => Object.hash(texto, ehNegativa, requerInputAdicional);
}
