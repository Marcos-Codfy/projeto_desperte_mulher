// Botão de Saída Rápida — visível no header de TODA página.
//
// Comportamento:
//   1. Usuária clica (ou pressiona Esc).
//   2. Aparece um modal de confirmação rápida.
//   3. Se confirmar, executa `aoConfirmarSaida` — que na Fase 6
//      vira a chamada JS real (window.location.replace + clear).
//
// Em mobile (largura < tablet) o botão fica compacto (só ícone).
// Em desktop, mostra ícone + texto "Sair".

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/widgets/seguranca/confirmacao_saida_modal.dart';

class BotaoSaidaRapida extends StatelessWidget {
  /// Callback chamado quando a usuária CONFIRMA que quer sair.
  /// É aqui que o caller liga `sairRapido()` do helper web na Fase 6.
  final VoidCallback aoConfirmarSaida;

  const BotaoSaidaRapida({super.key, required this.aoConfirmarSaida});

  void _abrirModal(BuildContext context) async {
    final confirmou = await mostrarConfirmacaoSaidaModal(context);
    if (confirmou == true) aoConfirmarSaida();
  }

  @override
  Widget build(BuildContext context) {
    final estreita = MediaQuery.sizeOf(context).width < AppDimensoes.breakpointTablet;

    return Semantics(
      button: true,
      label: AppStrings.saidaRapidaTooltip,
      child: Tooltip(
        message: AppStrings.saidaRapidaTooltip,
        child: TextButton.icon(
          onPressed: () => _abrirModal(context),
          icon: const Icon(Icons.exit_to_app, color: AppCores.erro),
          label: estreita
              ? const SizedBox.shrink()
              : Text(
                  AppStrings.saidaRapida,
                  style: AppTipografia.botao.copyWith(color: AppCores.erro),
                ),
          style: TextButton.styleFrom(
            foregroundColor: AppCores.erro,
            backgroundColor: AppCores.erroFundo,
            padding: EdgeInsets.symmetric(
              horizontal: estreita ? AppDimensoes.e12 : AppDimensoes.e16,
              vertical: AppDimensoes.e8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensoes.raioPilula),
            ),
            minimumSize: const Size(
              AppDimensoes.tamanhoMinimoToque,
              AppDimensoes.tamanhoMinimoToque,
            ),
          ),
        ),
      ),
    );
  }
}
