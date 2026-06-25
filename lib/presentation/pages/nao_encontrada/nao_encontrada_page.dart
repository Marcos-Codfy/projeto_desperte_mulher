// 404 acolhedor.
import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class NaoEncontradaPage extends StatelessWidget {
  const NaoEncontradaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloH1(AppStrings.paginaNaoEncontradaTitulo),
          const SizedBox(height: AppDimensoes.e16),
          const Paragrafo(AppStrings.paginaNaoEncontradaTexto, grande: true),
          const SizedBox(height: AppDimensoes.e24),
          BotaoPrimario(
            texto: AppStrings.paginaNaoEncontradaBotao,
            icone: Icons.home_outlined,
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
