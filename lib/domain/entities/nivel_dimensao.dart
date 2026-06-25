// Níveis Likert das duas dimensões da AR PAX.
//
// Vulnerabilidade e Ameaça têm vocabulários distintos por escolha
// metodológica do Felipe Scarpelli — Vulnerabilidade usa "Muito Baixa/
// Baixa/Média/Alta/Muito Alta" e Ameaça usa "Insignificante/Pequena/
// Moderada/Significante/Extrema". Mantemos os termos exatos do artigo.
//
// As faixas numéricas vêm do Quadro 7 do artigo de Scarpelli et al. (2024).

/// Nível Likert da Vulnerabilidade da vítima (V_final → categoria).
enum NivelVulnerabilidade {
  muitoBaixa,
  baixa,
  media,
  alta,
  muitoAlta;

  /// Rótulo legível para exibir na UI.
  String get label {
    switch (this) {
      case NivelVulnerabilidade.muitoBaixa:
        return 'Muito Baixa';
      case NivelVulnerabilidade.baixa:
        return 'Baixa';
      case NivelVulnerabilidade.media:
        return 'Média';
      case NivelVulnerabilidade.alta:
        return 'Alta';
      case NivelVulnerabilidade.muitoAlta:
        return 'Muito Alta';
    }
  }

  /// Classifica V_final em nível Likert.
  ///
  /// Faixas (Quadro 7 — Scarpelli 2024):
  ///   0.00 – 1.09 → Muito Baixa
  ///   1.10 – 2.21 → Baixa
  ///   2.22 – 3.58 → Média
  ///   3.59 – 4.65 → Alta
  ///   4.66 – 5.42 → Muito Alta
  ///
  /// V=0 (nenhuma marcação) cai em Muito Baixa por construção.
  static NivelVulnerabilidade fromValor(double v) {
    if (v <= 1.09) return NivelVulnerabilidade.muitoBaixa;
    if (v <= 2.21) return NivelVulnerabilidade.baixa;
    if (v <= 3.58) return NivelVulnerabilidade.media;
    if (v <= 4.65) return NivelVulnerabilidade.alta;
    return NivelVulnerabilidade.muitoAlta;
  }
}

/// Nível Likert da Ameaça do agressor (A_final → categoria).
enum NivelAmeaca {
  insignificante,
  pequena,
  moderada,
  significante,
  extrema;

  /// Rótulo legível para exibir na UI.
  String get label {
    switch (this) {
      case NivelAmeaca.insignificante:
        return 'Insignificante';
      case NivelAmeaca.pequena:
        return 'Pequena';
      case NivelAmeaca.moderada:
        return 'Moderada';
      case NivelAmeaca.significante:
        return 'Significante';
      case NivelAmeaca.extrema:
        return 'Extrema';
    }
  }

  /// Classifica A_final em nível Likert.
  ///
  /// Faixas (Quadro 7 — Scarpelli 2024):
  ///   0.00 – 1.32 → Insignificante
  ///   1.33 – 3.20 → Pequena
  ///   3.21 – 6.04 → Moderada
  ///   6.05 – 7.84 → Significante
  ///   7.85 – 9.17 → Extrema
  static NivelAmeaca fromValor(double a) {
    if (a <= 1.32) return NivelAmeaca.insignificante;
    if (a <= 3.20) return NivelAmeaca.pequena;
    if (a <= 6.04) return NivelAmeaca.moderada;
    if (a <= 7.84) return NivelAmeaca.significante;
    return NivelAmeaca.extrema;
  }
}
