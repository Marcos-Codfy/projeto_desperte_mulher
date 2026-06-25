// Tela "Apoios" — todos os parceiros e apoiadores institucionais.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_assets.dart';
import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/presentation/widgets/cards/card_apoiador.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class ApoiosPage extends StatelessWidget {
  const ApoiosPage({super.key});

  static const _apoiadores = <(String, String, String?)>[
    (
      'Conselho Nacional de Justiça',
      'Apoio institucional. Co-instituidor do FONAR junto com o CNMP.',
      AppAssets.logoCnj,
    ),
    (
      'Conselho Nacional do Ministério Público',
      'Apoio institucional. Co-instituidor do FONAR.',
      AppAssets.logoCnmp,
    ),
    (
      'UniCatólica do Tocantins',
      'Apoio acadêmico, suporte à pesquisa e desenvolvimento.',
      AppAssets.logoCatolica,
    ),
    (
      'Secretaria da Mulher do Tocantins',
      'Institucionalização da metodologia AR PAX em nível estadual.',
      AppAssets.logoSecMulherTo,
    ),
    (
      'Secretaria da Mulher de Palmas',
      'Apoio municipal e rede de acolhimento em Palmas.',
      AppAssets.logoSecMulherPalmas,
    ),
    (
      'Lions Club',
      'Apoio comunitário e divulgação da rede de proteção.',
      AppAssets.logoLions,
    ),
    (
      'Patrulha Maria da Penha PMTO',
      'Patrulhamento especializado em medidas protetivas.',
      AppAssets.logoPatrulhaMP,
    ),
    (
      'Polícia Militar TO',
      'Atendimento de emergência e cumprimento de protetivas.',
      AppAssets.logoPmTo,
    ),
    (
      'Delegacia Virtual SINESP',
      'Registro online de ocorrências sem precisar ir presencialmente.',
      AppAssets.logoDelegaciaVirtual,
    ),
    (
      'Casa da Mulher Brasileira',
      'Equipamento federal de atendimento integral à mulher.',
      AppAssets.logoCasaMulher,
    ),
    (
      'NUDEM',
      'Núcleo de Defesa da Mulher da Defensoria Pública.',
      AppAssets.logoNudem,
    ),
    (
      'OAB Tocantins',
      'Comissão de Feminicídio da Ordem dos Advogados.',
      AppAssets.logoOabTo,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.sizeOf(context).width;
    final cardsPorLinha = largura >= AppDimensoes.breakpointDesktop
        ? 3
        : (largura >= AppDimensoes.breakpointTablet ? 2 : 1);

    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloH1('Quem caminha com a gente'),
          const SizedBox(height: AppDimensoes.e16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensoes.larguraMaximaTexto,
            ),
            child: const Paragrafo(
              'Estas instituições compõem a rede de apoio que sustenta '
              'a metodologia AR PAX e o atendimento às mulheres em '
              'situação de violência. Você não precisa conhecer todas — '
              'basta saber que existem.',
              grande: true,
            ),
          ),
          const SizedBox(height: AppDimensoes.e32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cardsPorLinha,
              crossAxisSpacing: AppDimensoes.e16,
              mainAxisSpacing: AppDimensoes.e16,
              childAspectRatio: 1.2,
            ),
            itemCount: _apoiadores.length,
            itemBuilder: (_, i) {
              final a = _apoiadores[i];
              return CardApoiador(
                nome: a.$1,
                descricao: a.$2,
                caminhoLogo: a.$3,
              );
            },
          ),
        ],
      ),
    );
  }
}
