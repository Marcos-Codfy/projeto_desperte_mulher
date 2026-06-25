// Tela de Termos / "Antes de começar".
// Microcopy reescrito conforme §5.5: sem "indispensável", sem cobrança.
// 2 botões: "Tenho dúvidas — voltar" e "Compreendi — continuar".

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_secundario.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class TermosPage extends StatelessWidget {
  const TermosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloH1(AppStrings.termosTitulo),
          const SizedBox(height: AppDimensoes.e16),
          const Paragrafo(AppStrings.termosSubtitulo, grande: true),
          const SizedBox(height: AppDimensoes.e32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimensoes.larguraMaximaTexto),
            child: const Paragrafo(AppStrings.termosCorpo),
          ),
          const SizedBox(height: AppDimensoes.e32),
          Wrap(
            spacing: AppDimensoes.e16,
            runSpacing: AppDimensoes.e12,
            children: [
              BotaoSecundario(
                texto: AppStrings.termosBotaoVoltar,
                aoPressionar: () => Navigator.of(context).pop(),
              ),
              BotaoPrimario(
                texto: AppStrings.termosBotaoContinuar,
                icone: Icons.arrow_forward,
                tamanho: TamanhoBotao.grande,
                aoPressionar: () =>
                    Navigator.of(context).pushNamed(AppRotas.avaliacao),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
