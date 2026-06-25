// Barra de navegação inferior fixa da AvaliacaoPage.
//
// Antes desse widget, os botões Voltar/Próximo viviam dentro do
// scrollview do conteúdo. Em mobile, isso obrigava a vítima a rolar
// até o fim da etapa para avançar. Tirar os botões dali e fixá-los
// no rodapé respeita o princípio de UX mobile-first: ações primárias
// na zona acessível do polegar.
//
// Layout:
//   ┌─────────────────────────────────────────────────────────────┐
//   │  [← Voltar]                       [    Próximo  →    ]       │  ← esta barra
//   └─────────────────────────────────────────────────────────────┘
//
// "Voltar" fica menor à esquerda (ação secundária). "Próximo" é o
// botão primário, ocupa mais espaço à direita (ação esperada).

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_secundario.dart';

class BarraNavegacaoEtapa extends StatelessWidget {
  /// Se mostrar o botão "Voltar".
  /// Na primeira etapa, escondemos para não confundir.
  final bool mostrarVoltar;

  /// Se o botão Próximo deve renderizar como "Ver resultado"
  /// (na última etapa).
  final bool ehUltimaEtapa;

  /// Disparado ao tocar Voltar (ignorado se mostrarVoltar = false).
  final VoidCallback aoVoltar;

  /// Disparado ao tocar Próximo / Ver resultado.
  final VoidCallback aoAvancar;

  const BarraNavegacaoEtapa({
    super.key,
    required this.mostrarVoltar,
    required this.ehUltimaEtapa,
    required this.aoVoltar,
    required this.aoAvancar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e16,
        vertical: AppDimensoes.e12,
      ),
      decoration: const BoxDecoration(
        color: AppCores.fundoCard,
        border: Border(
          top: BorderSide(color: AppCores.divisor, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (mostrarVoltar)
              Expanded(
                flex: 2,
                child: BotaoSecundario(
                  texto: AppStrings.avaliacaoVoltar,
                  icone: Icons.arrow_back,
                  aoPressionar: aoVoltar,
                ),
              )
            else
              const Spacer(flex: 2),
            const SizedBox(width: AppDimensoes.e12),
            Expanded(
              flex: 3,
              child: BotaoPrimario(
                texto: ehUltimaEtapa
                    ? AppStrings.avaliacaoVerResultado
                    : AppStrings.avaliacaoProximo,
                icone: ehUltimaEtapa ? Icons.check : Icons.arrow_forward,
                tamanho: TamanhoBotao.grande,
                aoPressionar: aoAvancar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
