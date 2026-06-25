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
              // Layout adaptativo dos botões:
              //   • Em mobile estreito (modal < 380px): empilhamos em
              //     COLUNA com largura cheia. Secundária acima,
              //     primária abaixo (mais perto do polegar). Padrão
              //     usado por WhatsApp/Telegram/iOS sheets — mais
              //     limpo que dois botões soltos alinhados à direita.
              //   • Em desktop (≥ 380px): lado-a-lado à direita,
              //     primária à direita (padrão Material).
              //
              // O LayoutBuilder vê a largura do modal, não da tela —
              // num celular de 360 px o modal real tem ~280 px depois
              // da margem do Dialog.
              LayoutBuilder(
                builder: (ctx2, constraints) {
                  final empilhar = constraints.maxWidth < 380;

                  final botaoCancelar = BotaoSecundario(
                    texto: AppStrings.modalSaidaCancelar,
                    aoPressionar: () => Navigator.of(ctx).pop(false),
                    largura100: empilhar,
                  );
                  final botaoConfirmar = BotaoPrimario(
                    texto: AppStrings.modalSaidaConfirmar,
                    icone: Icons.exit_to_app,
                    aoPressionar: () => Navigator.of(ctx).pop(true),
                    largura100: empilhar,
                  );

                  if (empilhar) {
                    return Column(
                      children: [
                        botaoCancelar,
                        const SizedBox(height: AppDimensoes.e12),
                        botaoConfirmar,
                      ],
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      botaoCancelar,
                      const SizedBox(width: AppDimensoes.e12),
                      botaoConfirmar,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
