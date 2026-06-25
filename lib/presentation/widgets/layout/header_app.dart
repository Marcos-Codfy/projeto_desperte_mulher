// Header padrão da aplicação: nome da plataforma à esquerda + botão Sair.
//
// Por enquanto, o "callback de saída" é passado de fora — na Fase 6
// o ScaffoldAcolhedor (que monta este header) liga no helper web real.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_assets.dart';
import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_saida_rapida.dart';

class HeaderApp extends StatelessWidget {
  final VoidCallback aoConfirmarSaida;

  const HeaderApp({super.key, required this.aoConfirmarSaida});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensoes.alturaHeader,
      decoration: BoxDecoration(
        color: AppCores.fundo,
        border: Border(bottom: BorderSide(color: AppCores.divisor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensoes.e16),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRotas.home,
                  (route) => false,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.logoApp,
                      width: 36,
                      height: 36,
                      filterQuality: FilterQuality.medium,
                      semanticLabel: AppStrings.nomeProduto,
                    ),
                    const SizedBox(width: AppDimensoes.e12),
                    Flexible(
                      child: Text(
                        AppStrings.nomeProduto,
                        style: AppTipografia.tituloH3.copyWith(
                          color: AppCores.primariaEscura,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BotaoSaidaRapida(aoConfirmarSaida: aoConfirmarSaida),
          ],
        ),
      ),
    );
  }
}
