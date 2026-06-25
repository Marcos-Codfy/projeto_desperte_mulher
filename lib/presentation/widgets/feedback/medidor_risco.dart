// Medidor de risco sticky no rodapé da AvaliacaoPage.
//
// Mostra UMA barra horizontal que se enche conforme a usuária responde,
// com cor que evolui suavemente do verde-sálvia (paz) ao tom do grau
// projetado atual.
//
// PRINCÍPIO: nunca mostra número bruto durante o preenchimento.
// Número aparece só na tela de Resultado, contextualizado.
//
// Animação:
//   - 600ms entre estados (Tween) — suave o suficiente pra ser percebida
//     mas curta o suficiente pra não atrapalhar.
//   - Respeita `prefers-reduced-motion` (usuária com sensibilidade
//     a animações no SO recebe transição instantânea).

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/domain/entities/grau_risco.dart';

class MedidorRisco extends StatelessWidget {
  /// Quanto da barra está cheia: 0.0 = vazia, 1.0 = cheia.
  /// Tipicamente vinculado a "respostas dadas / total de perguntas".
  final double percentualPreenchido;

  /// Grau atualmente projetado pelas respostas dadas até aqui.
  /// Define a cor da barra. Se null, usa verde-sálvia (paz).
  final GrauRisco? grauProjetado;

  const MedidorRisco({
    super.key,
    required this.percentualPreenchido,
    this.grauProjetado,
  });

  Color _corDoGrau(GrauRisco? g) {
    switch (g) {
      case GrauRisco.muitoBaixo:
        return AppCores.grauMuitoBaixo;
      case GrauRisco.baixo:
        return AppCores.grauBaixo;
      case GrauRisco.moderado:
        return AppCores.grauModerado;
      case GrauRisco.alto:
        return AppCores.grauAlto;
      case GrauRisco.extremo:
        return AppCores.grauExtremo;
      case null:
        return AppCores.terciaria;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduzirMovimento = MediaQuery.disableAnimationsOf(context);
    final cor = _corDoGrau(grauProjetado);
    final percent = percentualPreenchido.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e16,
        vertical: AppDimensoes.e12,
      ),
      decoration: const BoxDecoration(
        color: AppCores.fundoCard,
        border: Border(
          top: BorderSide(color: AppCores.divisor, width: 1),
        ),
        boxShadow: AppSombras.card,
      ),
      child: Semantics(
        label: AppStrings.avaliacaoMedidorTexto,
        value: '${(percent * 100).round()} por cento concluído',
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.avaliacaoMedidorTexto,
              style: AppTipografia.corpoPequeno.copyWith(
                color: AppCores.textoSecundario,
              ),
            ),
            const SizedBox(height: AppDimensoes.e8),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensoes.raioPilula),
              child: SizedBox(
                height: 10,
                child: Stack(
                  children: [
                    Container(color: AppCores.divisor),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: percent),
                      duration: reduzirMovimento
                          ? Duration.zero
                          : const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (_, valor, _) {
                        return FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: valor,
                          child: TweenAnimationBuilder<Color?>(
                            tween: ColorTween(begin: AppCores.terciaria, end: cor),
                            duration: reduzirMovimento
                                ? Duration.zero
                                : const Duration(milliseconds: 600),
                            builder: (_, corAnim, _) => Container(
                              color: corAnim ?? cor,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
