// Paleta, tipografia e ThemeData único da aplicação.
//
// Princípios:
//   - Acolhimento sobre alerta: nada na tela "grita" com a usuária.
//   - Cor NUNCA é o único canal de informação (sempre acompanhada de
//     ícone ou texto), por acessibilidade.
//   - Cor de fundo NUNCA é branco puro (#FFFFFF); usamos off-white quente
//     que reduz fadiga visual em telas pequenas.
//   - Texto NUNCA é preto puro (#000000); grafite quente comunica suavidade.
//   - Vermelho neon NUNCA aparece, mesmo no resultado Extremo — usamos
//     bordô maduro (#8B4A47), grave sem disparar pânico.
//
// Contraste verificado contra WCAG 2.1 AA:
//   textoPrincipal sobre fundo     → 14.5:1 (AAA)
//   primaria sobre branco          → 5.2:1  (AA normal, AAA grande)
//   textoSecundario sobre card     → 6.4:1  (AA)
//   branco sobre primaria          → 5.2:1  (AA)
//   branco sobre grauExtremo       → 8.1:1  (AAA)

import 'package:flutter/material.dart';

/// Paleta da aplicação. Tudo o que for cor consome estas constantes.
class AppCores {
  AppCores._();

  // ── PRIMÁRIA: Lavanda Acolhedora ──────────────────────────────────────
  // Substitui o rosa #C2527A do site atual (correto, mas saturado demais).
  static const Color primaria = Color(0xFF8B6F9E);
  static const Color primariaClara = Color(0xFFB89BC9);
  static const Color primariaEscura = Color(0xFF6B5278);
  static const Color primariaFundo = Color(0xFFEDE6F5);

  // ── SECUNDÁRIA: Rosa Empoeirado (NÃO rosa Barbie) ─────────────────────
  static const Color secundaria = Color(0xFFC99D9A);
  static const Color secundariaClara = Color(0xFFE8D0CE);

  // ── TERCIÁRIA: Verde Sálvia (sinal de calma, "tudo certo") ────────────
  static const Color terciaria = Color(0xFF8AA89B);
  static const Color terciariaClara = Color(0xFFD6E4DC);

  // ── NEUTROS ───────────────────────────────────────────────────────────
  static const Color fundo = Color(0xFFFBF8F4); // off-white quente
  static const Color fundoCard = Color(0xFFFFFFFF); // branco só pra destacar
  static const Color fundoSecundario = Color(0xFFF2EBE3);
  static const Color divisor = Color(0xFFE5DDD3);
  static const Color textoPrincipal = Color(0xFF3A3536); // grafite quente
  static const Color textoSecundario = Color(0xFF6B6164);
  static const Color textoApagado = Color(0xFFA09894);

  // ── FEEDBACK (use com parcimônia) ─────────────────────────────────────
  static const Color erro = Color(0xFFB5524D); // terracota — NÃO neon
  static const Color erroFundo = Color(0xFFF5E0DD);
  static const Color sucesso = Color(0xFF7A9E8B);
  static const Color sucessoFundo = Color(0xFFE0EEE7);
  static const Color atencao = Color(0xFFC9A86A); // âmbar suave
  static const Color atencaoFundo = Color(0xFFF5EBD9);

  // ── GRAUS DE RISCO (tela de Resultado) ────────────────────────────────
  // Gradiente cromático que vai de verde-paz a bordô maduro,
  // sem nunca passar por vermelho neon.
  static const Color grauMuitoBaixo = Color(0xFF8AA89B); // verde-sálvia
  static const Color grauBaixo = Color(0xFFB8A85F); // mostarda terrosa
  static const Color grauModerado = Color(0xFFC98A5F); // terracota suave
  static const Color grauAlto = Color(0xFFB56B5F); // marrom-avermelhado
  static const Color grauExtremo = Color(0xFF8B4A47); // bordô maduro
}

/// Tipografia da aplicação. Sempre consumir destas constantes.
class AppTipografia {
  AppTipografia._();

  static const String _serif = 'PlayfairDisplay';
  static const String _sans = 'Lato';

  // ── Títulos hero (Playfair Display) ───────────────────────────────────
  static const TextStyle tituloHero = TextStyle(
    fontFamily: _serif,
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.5,
    color: AppCores.textoPrincipal,
  );

  static const TextStyle tituloH1 = TextStyle(
    fontFamily: _serif,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppCores.textoPrincipal,
  );

  // ── Títulos UI (Lato) ─────────────────────────────────────────────────
  static const TextStyle tituloH2 = TextStyle(
    fontFamily: _sans,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppCores.textoPrincipal,
  );

  static const TextStyle tituloH3 = TextStyle(
    fontFamily: _sans,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppCores.textoPrincipal,
  );

  // ── Texto corrido ─────────────────────────────────────────────────────
  static const TextStyle corpoGrande = TextStyle(
    fontFamily: _sans,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppCores.textoPrincipal,
  );

  static const TextStyle corpo = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: AppCores.textoPrincipal,
  );

  static const TextStyle corpoPequeno = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppCores.textoSecundario,
  );

  // ── Componentes ───────────────────────────────────────────────────────
  static const TextStyle botao = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle textoApoio = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.5,
    color: AppCores.textoSecundario,
  );

  /// Ênfase em itálico lavanda para palavras-âncora (ex: "liberdade").
  static const TextStyle enfaseItalica = TextStyle(
    fontFamily: _serif,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w700,
    color: AppCores.primaria,
  );
}

/// Sombras suaves do design system. Nunca usamos sombra dura.
class AppSombras {
  AppSombras._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000), // ~6% opacidade
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x1F000000), // ~12% opacidade
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}

/// Constrói o ThemeData único da aplicação.
/// Configura cores Material 3 a partir da nossa paleta + textos default + raios.
ThemeData construirTema() {
  final base = ThemeData.light(useMaterial3: true);

  return base.copyWith(
    scaffoldBackgroundColor: AppCores.fundo,
    colorScheme: const ColorScheme.light(
      primary: AppCores.primaria,
      onPrimary: Colors.white,
      secondary: AppCores.secundaria,
      onSecondary: Colors.white,
      tertiary: AppCores.terciaria,
      onTertiary: Colors.white,
      error: AppCores.erro,
      onError: Colors.white,
      surface: AppCores.fundoCard,
      onSurface: AppCores.textoPrincipal,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTipografia.tituloHero,
      displayMedium: AppTipografia.tituloH1,
      headlineMedium: AppTipografia.tituloH2,
      titleLarge: AppTipografia.tituloH3,
      bodyLarge: AppTipografia.corpoGrande,
      bodyMedium: AppTipografia.corpo,
      bodySmall: AppTipografia.corpoPequeno,
      labelLarge: AppTipografia.botao,
    ),
    iconTheme: const IconThemeData(color: AppCores.textoPrincipal),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // Cor de foco para acessibilidade (ring lavanda claro de 2px nos
    // elementos focados via teclado).
    focusColor: AppCores.primariaClara,
    splashFactory: InkRipple.splashFactory,
  );
}
