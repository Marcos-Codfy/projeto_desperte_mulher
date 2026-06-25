// Tela "Sobre" — contexto da plataforma e dos apoiadores.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_assets.dart';
import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/presentation/widgets/cards/card_apoiador.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  static const _texto = '''
O Desperte Mulher nasceu do encontro de quem trabalha todos os dias com a segurança das mulheres — policiais, juristas, profissionais da rede de apoio — e quem dedicou décadas ao estudo científico da violência doméstica.

A plataforma aplica a metodologia AR PAX (Análise de Risco PAX), criada por Felipe Scarpelli de Andrade e publicada em 2024 na Revista Brasileira de Ciências Policiais. Ela transforma as 27 perguntas oficiais do FONAR — Formulário Nacional de Avaliação de Risco, instituído pela Resolução Conjunta nº 5/2020 do CNJ e CNMP — em um grau de risco objetivo, em vez de deixar a interpretação na intuição de quem aplica o formulário.

A metodologia já é adotada pelo Tribunal de Justiça do Tocantins e tem institucionalização pela Secretaria da Mulher do Estado, com parcerias confirmadas com o Conselho Nacional de Justiça, o Conselho Nacional do Ministério Público, a Casa da Mulher Brasileira, a Casa da Mulher Tocantinense, a Patrulha Maria da Penha, a Polícia Civil e Militar do Tocantins, a OAB-TO, o Lions Club, entre outras.

Esta versão da plataforma foi construída como um trabalho acadêmico, com foco em qualidade técnica, acessibilidade e cuidado com quem vai usá-la. Se você é profissional de uma instituição parceira e quer entender o motor de cálculo em detalhe, abra a página "O que é AR PAX".
''';

  static const _apoiadores = <(String, String?)>[
    ('CNJ', AppAssets.logoCnj),
    ('CNMP', AppAssets.logoCnmp),
    ('UniCatólica do Tocantins', AppAssets.logoCatolica),
    ('Secretaria da Mulher TO', AppAssets.logoSecMulherTo),
    ('Secretaria da Mulher de Palmas', AppAssets.logoSecMulherPalmas),
    ('Lions Club', AppAssets.logoLions),
    ('Patrulha Maria da Penha', AppAssets.logoPatrulhaMP),
    ('Polícia Militar TO', AppAssets.logoPmTo),
    ('Delegacia Virtual SINESP', AppAssets.logoDelegaciaVirtual),
    ('Casa da Mulher Brasileira', AppAssets.logoCasaMulher),
    ('NUDEM', AppAssets.logoNudem),
    ('OAB Tocantins', AppAssets.logoOabTo),
  ];

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.sizeOf(context).width;
    final cardsPorLinha = largura >= AppDimensoes.breakpointDesktop
        ? 4
        : (largura >= AppDimensoes.breakpointTablet ? 3 : 2);

    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloH1('Sobre a plataforma'),
          const SizedBox(height: AppDimensoes.e16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimensoes.larguraMaximaTexto),
            child: const Paragrafo(_texto),
          ),
          const SizedBox(height: AppDimensoes.e32),
          const TituloH2('Quem caminha com a gente'),
          const SizedBox(height: AppDimensoes.e16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: cardsPorLinha,
            crossAxisSpacing: AppDimensoes.e16,
            mainAxisSpacing: AppDimensoes.e16,
            childAspectRatio: 1.1,
            children: _apoiadores
                .map((a) => CardApoiador(nome: a.$1, caminhoLogo: a.$2))
                .toList(),
          ),
        ],
      ),
    );
  }
}
