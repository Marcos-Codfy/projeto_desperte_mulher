// ResultadoPage — recebe um ResultadoArpax via arguments e exibe o
// CardResultado + CTAs para a rede de apoio.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/domain/entities/resultado_arpax.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_secundario.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_texto.dart';
import 'package:desperte_mulher/presentation/widgets/cards/card_resultado.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class ResultadoPage extends StatelessWidget {
  const ResultadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final resultado = args is ResultadoArpax ? args : null;

    if (resultado == null) {
      return ScaffoldAcolhedor(
        conteudo: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TituloH1(AppStrings.resultadoNenhumResultadoTitulo),
            const SizedBox(height: AppDimensoes.e16),
            const Paragrafo(
              AppStrings.resultadoNenhumResultadoTexto,
              grande: true,
            ),
            const SizedBox(height: AppDimensoes.e24),
            BotaoPrimario(
              texto: AppStrings.homeCTA,
              aoPressionar: () =>
                  Navigator.of(context).pushReplacementNamed(AppRotas.home),
            ),
          ],
        ),
      );
    }

    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloH1(AppStrings.resultadoTitulo),
          const SizedBox(height: AppDimensoes.e8),
          const Paragrafo(AppStrings.resultadoSubtitulo, grande: true),
          const SizedBox(height: AppDimensoes.e24),
          CardResultado(resultado: resultado),
          const SizedBox(height: AppDimensoes.e32),
          const TituloH2(AppStrings.resultadoProximosPassosTitulo),
          const SizedBox(height: AppDimensoes.e16),
          Wrap(
            spacing: AppDimensoes.e16,
            runSpacing: AppDimensoes.e12,
            children: [
              BotaoPrimario(
                texto: AppStrings.resultadoCTAFalar,
                icone: Icons.headset_mic_outlined,
                aoPressionar: () =>
                    Navigator.of(context).pushNamed(AppRotas.falar),
              ),
              BotaoSecundario(
                texto: AppStrings.resultadoCTAApoios,
                icone: Icons.diversity_3_outlined,
                aoPressionar: () =>
                    Navigator.of(context).pushNamed(AppRotas.apoios),
              ),
            ],
          ),
          const SizedBox(height: AppDimensoes.e24),
          BotaoTexto(
            texto: AppStrings.resultadoRefazer,
            icone: Icons.refresh,
            aoPressionar: () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppRotas.home,
              (_) => false,
            ),
          ),
        ],
      ),
    );
  }
}
