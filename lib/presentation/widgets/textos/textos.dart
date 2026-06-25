// Widgets de texto reutilizáveis.
//
// Aplicam o estilo do tema e dispensam quem usa de lembrar a TextStyle.
// Também tratam o padrão *palavra* → ênfase em itálico lavanda
// (usado nos títulos hero, ex: "Conhecimento é o primeiro passo para a *liberdade*").

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_theme.dart';

/// Título hero (Playfair Display, 48px). Suporta marcação *palavra*
/// para ênfase em itálico lavanda — usado nos H1 da home.
class TituloHero extends StatelessWidget {
  final String texto;
  final TextAlign textAlign;

  const TituloHero(this.texto, {super.key, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: _construirTextoComEnfase(
        texto,
        AppTipografia.tituloHero,
        textAlign,
      ),
    );
  }
}

/// Título H1 (Playfair Display, 32px).
class TituloH1 extends StatelessWidget {
  final String texto;
  final TextAlign textAlign;

  const TituloH1(this.texto, {super.key, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: _construirTextoComEnfase(texto, AppTipografia.tituloH1, textAlign),
    );
  }
}

/// Título H2 (Lato bold, 24px).
class TituloH2 extends StatelessWidget {
  final String texto;
  final TextAlign textAlign;

  const TituloH2(this.texto, {super.key, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(texto, style: AppTipografia.tituloH2, textAlign: textAlign),
    );
  }
}

/// Título H3 (Lato semibold, 18px).
class TituloH3 extends StatelessWidget {
  final String texto;
  final TextAlign textAlign;

  const TituloH3(this.texto, {super.key, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(texto, style: AppTipografia.tituloH3, textAlign: textAlign),
    );
  }
}

/// Parágrafo padrão (Lato 16px).
class Paragrafo extends StatelessWidget {
  final String texto;
  final TextAlign textAlign;
  final bool grande;

  const Paragrafo(
    this.texto, {
    super.key,
    this.textAlign = TextAlign.left,
    this.grande = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: grande ? AppTipografia.corpoGrande : AppTipografia.corpo,
      textAlign: textAlign,
    );
  }
}

/// Texto de apoio (itálico, secundário) — usado embaixo das perguntas
/// para microcopy acolhedor.
class TextoApoio extends StatelessWidget {
  final String texto;
  final TextAlign textAlign;

  const TextoApoio(this.texto, {super.key, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: AppTipografia.textoApoio, textAlign: textAlign);
  }
}

// ── Helper: parser *palavra* → ênfase em itálico lavanda ────────────────

/// Constrói um RichText quebrando o texto pelas marcações *…*.
/// Cada trecho entre asteriscos vira itálico lavanda (`enfaseItalica`).
Widget _construirTextoComEnfase(
  String texto,
  TextStyle estiloBase,
  TextAlign alinhamento,
) {
  if (!texto.contains('*')) {
    return Text(texto, style: estiloBase, textAlign: alinhamento);
  }

  final spans = <TextSpan>[];
  final partes = texto.split('*');
  for (var i = 0; i < partes.length; i++) {
    final ehEnfase = i.isOdd; // partes ímpares estão entre asteriscos
    spans.add(TextSpan(
      text: partes[i],
      style: ehEnfase
          ? estiloBase.merge(AppTipografia.enfaseItalica)
          : estiloBase,
    ));
  }
  return Text.rich(
    TextSpan(children: spans),
    textAlign: alinhamento,
    textHeightBehavior: const TextHeightBehavior(
      applyHeightToFirstAscent: true,
      applyHeightToLastDescent: true,
      leadingDistribution: TextLeadingDistribution.even,
    ),
  );
}
