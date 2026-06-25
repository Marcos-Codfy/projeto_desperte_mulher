// Modal de aviso no primeiro acesso: explica sobre aba anônima e botão Sair.
//
// É um modal informativo, sem retorno relevante — só fecha quando a
// usuária confirma. Deve aparecer só na PRIMEIRA visita da sessão.
// A lógica de "mostrar só uma vez" será disparada na HomePage.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

Future<void> mostrarAvisoHistoricoModal(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensoes.raioGrande),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensoes.e24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloH2(AppStrings.modalAvisoTitulo),
              const SizedBox(height: AppDimensoes.e16),
              const Paragrafo(AppStrings.modalAvisoTexto),
              const SizedBox(height: AppDimensoes.e24),
              Align(
                alignment: Alignment.centerRight,
                child: BotaoPrimario(
                  texto: AppStrings.modalAvisoBotao,
                  aoPressionar: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
