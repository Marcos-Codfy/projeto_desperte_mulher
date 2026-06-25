// Os 6 critérios da metodologia AR PAX (Análise de Risco PAX).
//
// Cada critério sabe três coisas sobre si:
//   1. A dimensão a que pertence (Vulnerabilidade ou Ameaça)
//   2. O peso que recebe ao compor V_final ou A_final
//   3. Como converter "número de marcações" em "nível Likert (1-5)"
//
// FONTES AUTORITATIVAS:
//   - Pesos:    aba "NÍVEL CRITÉRIO" da Planilha Ajustada.xlsm (K3-K5, N3-N5)
//   - Faixas:   mesma aba, validadas contra o Quadro 7 do artigo de
//               Scarpelli et al. (2024).
//
// VALIDAÇÕES MATEMÁTICAS QUE PROVAM QUE ESTÁ CORRETO:
//   V_max = 5 × (1/3 + 1/2 + 1/4) = 5 × 13/12 = 5.4166… → bate com 5.42 ✓
//   A_max = 5 × (1   + 1/2 + 1/3) = 5 × 11/6  = 9.1666… → bate com 9.17 ✓

/// Dimensão a que um critério pertence.
enum Dimensao { vulnerabilidade, ameaca }

/// Os 6 critérios oficiais da AR PAX.
///
/// Trê de Vulnerabilidade (VC1, VC2, VC3) e três de Ameaça (AC1, AC2, AC3).
/// Cada um tem peso e tabela de classificação Likert próprios.
enum CriterioArpax {
  atratibilidade,
  exposicao,
  casuistica,
  motivacao,
  historico,
  tendencia;

  /// Sigla curta (VC1, VC2, VC3, AC1, AC2, AC3) — usada em logs técnicos.
  String get sigla {
    switch (this) {
      case CriterioArpax.atratibilidade:
        return 'VC1';
      case CriterioArpax.exposicao:
        return 'VC2';
      case CriterioArpax.casuistica:
        return 'VC3';
      case CriterioArpax.motivacao:
        return 'AC1';
      case CriterioArpax.historico:
        return 'AC2';
      case CriterioArpax.tendencia:
        return 'AC3';
    }
  }

  /// Nome humano (Atratibilidade, Exposição, …).
  String get nomeCompleto {
    switch (this) {
      case CriterioArpax.atratibilidade:
        return 'Atratibilidade';
      case CriterioArpax.exposicao:
        return 'Exposição';
      case CriterioArpax.casuistica:
        return 'Casuística';
      case CriterioArpax.motivacao:
        return 'Motivação';
      case CriterioArpax.historico:
        return 'Histórico';
      case CriterioArpax.tendencia:
        return 'Tendência';
    }
  }

  /// Peso de precedência do critério dentro da sua dimensão.
  ///
  /// Vulnerabilidade: VC1=1/3, VC2=1/2, VC3=1/4 (denominadores 2,3,4).
  /// Ameaça:          AC1=1,   AC2=1/3, AC3=1/2 (denominadores 1,2,3).
  ///
  /// A Ameaça recebe escala maior (9.17 vs 5.42 da Vulnerabilidade)
  /// porque na prática é o que "puxa o gatilho" do risco extremo —
  /// decisão metodológica do Felipe Scarpelli.
  double get peso {
    switch (this) {
      case CriterioArpax.atratibilidade:
        return 1 / 3;
      case CriterioArpax.exposicao:
        return 1 / 2;
      case CriterioArpax.casuistica:
        return 1 / 4;
      case CriterioArpax.motivacao:
        return 1.0;
      case CriterioArpax.historico:
        return 1 / 3;
      case CriterioArpax.tendencia:
        return 1 / 2;
    }
  }

  /// A qual dimensão (Vulnerabilidade ou Ameaça) este critério pertence.
  Dimensao get dimensao {
    switch (this) {
      case CriterioArpax.atratibilidade:
      case CriterioArpax.exposicao:
      case CriterioArpax.casuistica:
        return Dimensao.vulnerabilidade;
      case CriterioArpax.motivacao:
      case CriterioArpax.historico:
      case CriterioArpax.tendencia:
        return Dimensao.ameaca;
    }
  }

  /// Converte o número de marcações deste critério em nível Likert 1..5.
  ///
  /// Cada critério tem uma tabela diferente porque o número máximo de
  /// marcações possíveis varia: VC1=7, VC2=8, VC3=14, AC1=12, AC2=14, AC3=16.
  ///
  /// REGRA DE SATURAÇÃO: marcações acima do teto não inflam o nível;
  /// o resultado fica grampeado em 5 (Muito Alta / Extrema). Isso evita
  /// inflação artificial por redundância entre perguntas.
  ///
  /// Marcações ≤ 0 retornam 0 — significa "critério não acionado".
  /// Isso é importante para o cálculo de V_final / A_final não somar
  /// resíduos quando a usuária ainda não tocou em nada relacionado.
  int classificarLikert(int marcacoes) {
    if (marcacoes <= 0) return 0;

    switch (this) {
      case CriterioArpax.atratibilidade: // teto = 7
        if (marcacoes <= 1) return 1; //   1   → Muito Baixa
        if (marcacoes <= 3) return 2; // 2-3   → Baixa
        if (marcacoes == 4) return 3; //   4   → Média
        if (marcacoes <= 6) return 4; // 5-6   → Alta
        return 5; //                       7+   → Muito Alta (saturação)

      case CriterioArpax.exposicao: // teto = 8
        if (marcacoes <= 1) return 1;
        if (marcacoes <= 3) return 2;
        if (marcacoes == 4) return 3;
        if (marcacoes <= 6) return 4;
        return 5; // 7-8+ → Muito Alta

      case CriterioArpax.casuistica: // teto = 14
        if (marcacoes <= 2) return 1;
        if (marcacoes <= 5) return 2;
        if (marcacoes <= 7) return 3;
        if (marcacoes <= 10) return 4;
        return 5; // 11-14+ → Muito Alta

      case CriterioArpax.motivacao: // teto = 12
        if (marcacoes <= 2) return 1; //          → Insignificante
        if (marcacoes <= 5) return 2; //          → Pequena
        if (marcacoes <= 7) return 3; //          → Moderada
        if (marcacoes <= 10) return 4; //         → Significante
        return 5; // 11-12+                       → Extrema

      case CriterioArpax.historico: // teto = 14
        if (marcacoes <= 2) return 1;
        if (marcacoes <= 5) return 2;
        if (marcacoes <= 7) return 3;
        if (marcacoes <= 10) return 4;
        return 5; // 11-14+ → Extrema

      case CriterioArpax.tendencia: // teto = 16
        if (marcacoes <= 3) return 1;
        if (marcacoes <= 6) return 2;
        if (marcacoes <= 9) return 3;
        if (marcacoes <= 12) return 4;
        return 5; // 13-16+ → Extrema
    }
  }

  /// Auxiliar: converte chave-string (vinda do JSON) em CriterioArpax.
  /// Usado pelo mapper. Aceita os mesmos identificadores que estão
  /// declarados nos JSONs de assets/mock/ (lowerCamelCase).
  static CriterioArpax? deString(String chave) {
    for (final c in CriterioArpax.values) {
      if (c.name == chave) return c;
    }
    return null;
  }
}
