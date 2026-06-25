// Modal de confirmação da Saída Rápida.
//
// Devolve `true` se a usuária confirmou que quer sair, `false`/null
// caso contrário. Pequeno o suficiente pra ser lido num piscar.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_secundario.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

/// Abre o modal de confirmação e devolve true se a usuária confirmou.
Future<bool?> mostrarConfirmacaoSaidaModal(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensoes.raioGrande),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensoes.e24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TituloH2(AppStrings.modalSaidaTitulo),
              const SizedBox(height: AppDimensoes.e16),
              const Paragrafo(AppStrings.modalSaidaTexto),
              const SizedBox(height: AppDimensoes.e24),
              // Wrap em vez de Row: em mobile estreito (≤ ~370px), os
              // dois botões não cabem lado-a-lado sem overflow. O Wrap
              // quebra automaticamente para coluna nesse caso — com a
              // ordem visual mantida (Cancelar em cima, Sim, sair agora
              // embaixo, primário continua sendo a ação mais acessível).
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppDimensoes.e12,
                runSpacing: AppDimensoes.e12,
                children: [
                  BotaoSecundario(
                    texto: AppStrings.modalSaidaCancelar,
                    aoPressionar: () => Navigator.of(ctx).pop(false),
                  ),
                  BotaoPrimario(
                    texto: AppStrings.modalSaidaConfirmar,
                    icone: Icons.exit_to_app,
                    aoPressionar: () => Navigator.of(ctx).pop(true),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
