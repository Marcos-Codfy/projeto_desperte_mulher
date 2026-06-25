// Tela "Falar com a rede" — telefones e canais da rede de apoio.
// Cards com `tel:` deeplink: no celular dispara o discador.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_assets.dart';
import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/presentation/widgets/cards/card_apoiador.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';
import 'package:desperte_mulher/web/browser_helpers.dart';

class FalarPage extends StatelessWidget {
  const FalarPage({super.key});

  /// Cada entrada: (nome, descrição, telefone, caminho do logo).
  /// `telefone` pode ser null pra serviços que não têm número direto.
  static const _canais = <(String, String, String?, String?)>[
    (
      'Central de Atendimento à Mulher',
      'Plantão 24h, em todo o Brasil. Escuta, orientação e encaminhamento.',
      '180',
      AppAssets.logo180,
    ),
    (
      'Polícia Militar',
      'Atendimento de emergência em todo o país.',
      '190',
      AppAssets.logoPmTo,
    ),
    (
      'Casa da Mulher Brasileira — Palmas',
      'Atendimento integral 24h. Acolhimento, orientação jurídica '
          'e abrigamento, se necessário.',
      null,
      AppAssets.logoCasaMulher,
    ),
    (
      'Patrulha Maria da Penha — TO',
      'Patrulhamento especializado. Procura mulheres com medida '
          'protetiva ativa.',
      null,
      AppAssets.logoPatrulhaMP,
    ),
    (
      'Delegacia Virtual SINESP',
      'Registre uma ocorrência online, sem precisar ir presencialmente.',
      null,
      AppAssets.logoDelegaciaVirtual,
    ),
    (
      'NUDEM — Defensoria Pública',
      'Defesa jurídica gratuita para mulheres em situação de violência.',
      null,
      AppAssets.logoNudem,
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
          const TituloH1('Falar com a rede de apoio'),
          const SizedBox(height: AppDimensoes.e16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensoes.larguraMaximaTexto,
            ),
            child: const Paragrafo(
              'Você pode entrar em contato com qualquer um destes '
              'canais. Cada um tem uma especialidade — escolha o que '
              'mais faz sentido para você agora. Em emergência, ligue '
              '190.',
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
              childAspectRatio: 1.1,
            ),
            itemCount: _canais.length,
            itemBuilder: (_, i) {
              final c = _canais[i];
              return CardApoiador(
                nome: c.$1,
                descricao: c.$2,
                telefoneAcao: c.$3,
                caminhoLogo: c.$4,
                aoTocar: c.$3 != null ? () => ligarPara(c.$3!) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
