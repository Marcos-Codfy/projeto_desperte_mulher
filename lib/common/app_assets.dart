// Catálogo de caminhos de assets (imagens, ícones).
//
// Centralizar evita typo de string espalhado pela base. Quando o Davi
// mandar os PNGs reais dos parceiros, é só dropar em
// assets/images/parceiros/ e ajustar o nome aqui.

class AppAssets {
  AppAssets._();

  // ── Pastas base ───────────────────────────────────────────────────────
  static const String _imgs = 'assets/images';
  static const String _parceiros = '$_imgs/parceiros';
  static const String _ilustracoes = '$_imgs/ilustracoes';

  // ── Logos institucionais ──────────────────────────────────────────────
  // Os PNG/JPG reais vivem em assets/images/parceiros/.
  static const String logoCnj = '$_parceiros/cnj.png';
  static const String logoCnmp = '$_parceiros/cnmp.png';
  static const String logoCatolica = '$_parceiros/logocatolica.png';
  static const String logoLions = '$_parceiros/lionsclub.png';
  static const String logoSecMulherPalmas = '$_parceiros/secmulherpalmas.png';
  static const String logoSecMulherTo =
      '$_parceiros/secretariadamulhertocantins.png';
  static const String logoPatrulhaMP = '$_parceiros/patrulhamariadapenha.png';
  static const String logoPmTo = '$_parceiros/pmto.png';
  static const String logoDelegaciaVirtual =
      '$_parceiros/delegaciavirtual.png';
  // Nome do arquivo exatamente como entregue pelo Davi.
  static const String logoCasaMulher = '$_parceiros/casamulherbrasileira.png';
  static const String logoNudem = '$_parceiros/nudem.jpg';
  static const String logoOabTo = '$_parceiros/oabto.jpeg';
  static const String logo180 = '$_parceiros/180.jpeg';

  // ── Ilustrações decorativas ───────────────────────────────────────────
  static const String ilustracaoHero = '$_ilustracoes/hero.png';
  static const String logoApp = '$_imgs/logo_desperte_mulher.png';
}
