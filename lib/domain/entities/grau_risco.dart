// Grau final de risco da avaliação AR PAX — o resultado que a usuária vê.
//
// 5 níveis: Muito Baixo, Baixo, Moderado, Alto, Extremo.
// Mapeamento entre dimensões → grau é feito pela Matriz 5×5 (Quadro 8
// do artigo) em lib/domain/usecases/cruzar_matriz_risco.dart.
//
// Aqui mantemos o microcopy contextual acolhedor (já reescrito conforme
// seção 5.5 do planejamento) junto do enum. Isso garante que, se mudarmos
// a palavra "moderado" para "intermediário", seja em UM lugar só.

/// Grau final de risco da avaliação AR PAX.
enum GrauRisco {
  muitoBaixo,
  baixo,
  moderado,
  alto,
  extremo;

  /// Sigla curta usada em logs e tabelas internas.
  String get sigla {
    switch (this) {
      case GrauRisco.muitoBaixo:
        return 'MB';
      case GrauRisco.baixo:
        return 'BA';
      case GrauRisco.moderado:
        return 'MO';
      case GrauRisco.alto:
        return 'AL';
      case GrauRisco.extremo:
        return 'EX';
    }
  }

  /// Rótulo legível para exibir na UI.
  String get label {
    switch (this) {
      case GrauRisco.muitoBaixo:
        return 'Muito Baixo';
      case GrauRisco.baixo:
        return 'Baixo';
      case GrauRisco.moderado:
        return 'Moderado';
      case GrauRisco.alto:
        return 'Alto';
      case GrauRisco.extremo:
        return 'Extremo';
    }
  }

  /// Microcopy contextual mostrado na tela de Resultado.
  ///
  /// PRINCÍPIO: nunca culpabiliza, nunca apavora, nunca minimiza.
  /// Reconhece o que ela viveu, valida e abre porta para a rede de apoio.
  /// (Reescrito conforme seção 5.5 do PLANEJAMENTO_FRONTEND.md)
  String get microcopyAcolhedor {
    switch (this) {
      case GrauRisco.muitoBaixo:
        return 'Pelo que você compartilhou, os sinais de risco imediato '
            'parecem baixos. Isso é uma boa notícia — e não invalida '
            'nada do que você está sentindo. A rede de apoio segue '
            'disponível sempre que você quiser conversar.';
      case GrauRisco.baixo:
        return 'Sua avaliação aponta para um risco baixo no momento. '
            'Continuar atenta aos sinais e ter por perto pessoas em '
            'quem você confia faz diferença. A rede de apoio está aqui '
            'se algo mudar.';
      case GrauRisco.moderado:
        return 'Sua avaliação aponta para um risco moderado. Vale '
            'considerar conversar com alguém da rede de apoio — '
            'profissionais que escutam sem julgamento e ajudam você a '
            'pensar nos próximos passos no seu ritmo.';
      case GrauRisco.alto:
        return 'Sua avaliação aponta para um risco alto. Você não '
            'precisa enfrentar isso sozinha. Sugerimos que entre em '
            'contato com a rede de apoio o quanto antes — eles podem '
            'ajudar a montar um plano de segurança junto com você.';
      case GrauRisco.extremo:
        return 'Sua avaliação aponta para um risco extremo. Por favor, '
            'busque acolhimento imediato pelos canais da rede de apoio. '
            'Se houver perigo agora, ligue 190. Você merece estar '
            'segura — e há quem possa caminhar com você nisso.';
    }
  }
}
