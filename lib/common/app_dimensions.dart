// Dimensões, espaçamentos, raios e breakpoints da aplicação.
//
// Princípio: sistema de 8 (padrão Material). Tudo é múltiplo de 8 ou 4.
// Área de toque mínima 48px (excede o WCAG de 44px — mãos trêmulas em
// situação de emergência precisam de área generosa).

class AppDimensoes {
  AppDimensoes._();

  // ── Espaçamentos (sistema de 8) ───────────────────────────────────────
  static const double e4 = 4.0;
  static const double e8 = 8.0;
  static const double e12 = 12.0;
  static const double e16 = 16.0;
  static const double e24 = 24.0;
  static const double e32 = 32.0;
  static const double e48 = 48.0;
  static const double e64 = 64.0;

  // ── Raios de canto ────────────────────────────────────────────────────
  static const double raioPequeno = 8.0; // inputs, chips
  static const double raioMedio = 16.0; // cards, botões
  static const double raioGrande = 24.0; // modais, containers
  static const double raioPilula = 999.0; // botões pílula

  // ── Áreas de toque ────────────────────────────────────────────────────
  /// Mínimo da área de toque — excede WCAG de 44px.
  static const double tamanhoMinimoToque = 48.0;

  // ── Breakpoints responsivos ───────────────────────────────────────────
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;

  /// Largura máxima do conteúdo principal em desktop.
  /// Acima disso, sobram margens laterais — leitura confortável.
  static const double larguraMaximaConteudo = 1200.0;

  /// Largura máxima de texto puro (artigos, termos): linha não fica longa.
  static const double larguraMaximaTexto = 720.0;

  // ── Tamanhos comuns ───────────────────────────────────────────────────
  static const double alturaHeader = 64.0;
  static const double alturaBotaoGrande = 56.0;
  static const double alturaBotaoMedio = 48.0;
  static const double alturaBotaoPequeno = 40.0;
}
