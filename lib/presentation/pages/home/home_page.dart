// Tela inicial. Hero, 3 cards "por que importa", CTA principal.
// É a porta de entrada — precisa comunicar acolhimento em 1 segundo.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/feedback/badge_seguranca.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/seguranca/aviso_historico_modal.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

/// Flag em memória: garante que o AvisoHistoricoModal apareça só uma vez
/// por sessão. Não pode ir pra localStorage (regra de sigilo da vítima).
///
/// Exposta como `@visibleForTesting` para que testes possam suprimir o
/// modal (que abre por postFrameCallback e quebra widget tests).
bool homePageAvisoHistoricoJaMostrado = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (!homePageAvisoHistoricoJaMostrado) {
      homePageAvisoHistoricoJaMostrado = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        mostrarAvisoHistoricoModal(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final largo =
        MediaQuery.sizeOf(context).width >= AppDimensoes.breakpointDesktop;
    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Hero(largo: largo),
          const SizedBox(height: AppDimensoes.e48),
          const TituloH2(AppStrings.homePorQueImportaTitulo),
          const SizedBox(height: AppDimensoes.e24),
          _CardsPorQueImporta(largo: largo),
          const SizedBox(height: AppDimensoes.e48),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final bool largo;
  const _Hero({required this.largo});

  @override
  Widget build(BuildContext context) {
    final conteudo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TituloHero(AppStrings.homeHeroTitulo),
        const SizedBox(height: AppDimensoes.e16),
        const Paragrafo(AppStrings.homeHeroSubtitulo, grande: true),
        const SizedBox(height: AppDimensoes.e32),
        BotaoPrimario(
          texto: AppStrings.homeCTA,
          tamanho: TamanhoBotao.grande,
          icone: Icons.arrow_forward,
          aoPressionar: () =>
              Navigator.of(context).pushNamed(AppRotas.termos),
        ),
        const SizedBox(height: AppDimensoes.e24),
        const Wrap(
          spacing: AppDimensoes.e8,
          runSpacing: AppDimensoes.e8,
          children: [
            BadgeSeguranca(
              texto: AppStrings.homeBadgeAnonimo,
              icone: Icons.shield_outlined,
            ),
            BadgeSeguranca(
              texto: AppStrings.homeBadgeGratuito,
              icone: Icons.eco_outlined,
            ),
            BadgeSeguranca(
              texto: AppStrings.homeBadgeCientifico,
              icone: Icons.school_outlined,
            ),
          ],
        ),
      ],
    );

    if (!largo) return conteudo;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: conteudo),
        const SizedBox(width: AppDimensoes.e48),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppCores.primariaFundo,
                borderRadius: BorderRadius.circular(AppDimensoes.raioGrande),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.spa_outlined,
                size: 96,
                color: AppCores.primaria,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardsPorQueImporta extends StatelessWidget {
  final bool largo;
  const _CardsPorQueImporta({required this.largo});

  static const _cards = [
    (AppStrings.homeCard1Titulo, AppStrings.homeCard1Texto, Icons.psychology_outlined),
    (AppStrings.homeCard2Titulo, AppStrings.homeCard2Texto, Icons.groups_outlined),
    (AppStrings.homeCard3Titulo, AppStrings.homeCard3Texto, Icons.lock_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final filhos = _cards
        .map((c) => _CardInfo(titulo: c.$1, texto: c.$2, icone: c.$3))
        .toList();

    if (!largo) {
      return Column(
        children: [
          for (final f in filhos) ...[
            f,
            const SizedBox(height: AppDimensoes.e16),
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final f in filhos) ...[
          Expanded(child: f),
          const SizedBox(width: AppDimensoes.e16),
        ],
      ]..removeLast(),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final String titulo;
  final String texto;
  final IconData icone;

  const _CardInfo({
    required this.titulo,
    required this.texto,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensoes.e24),
      decoration: BoxDecoration(
        color: AppCores.fundoCard,
        borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
        border: Border.all(color: AppCores.divisor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensoes.e8),
            decoration: BoxDecoration(
              color: AppCores.primariaFundo,
              borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
            ),
            child: Icon(icone, color: AppCores.primaria),
          ),
          const SizedBox(height: AppDimensoes.e16),
          TituloH3(titulo),
          const SizedBox(height: AppDimensoes.e8),
          Paragrafo(texto),
        ],
      ),
    );
  }
}
