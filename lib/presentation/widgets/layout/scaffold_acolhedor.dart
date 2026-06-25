// Scaffold base de toda página. Aplica fundo, header, footer e largura
// máxima do conteúdo. Substitui o Scaffold padrão.
//
// O atalho de teclado ESC vai entrar aqui na Fase 6 (junto com a
// integração real do helper web). Por enquanto, só o botão visível.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/widgets/layout/footer_app.dart';
import 'package:desperte_mulher/presentation/widgets/layout/header_app.dart';
import 'package:desperte_mulher/presentation/widgets/seguranca/confirmacao_saida_modal.dart';
import 'package:desperte_mulher/web/browser_helpers.dart' as web;

/// Callback chamado quando a usuária confirma a saída rápida.
/// Na Fase 6, isso vai apontar para `sairRapido()` do helper web.
typedef AoSairCallback = void Function();

class ScaffoldAcolhedor extends StatelessWidget {
  /// Conteúdo principal da página (acima do footer, abaixo do header).
  final Widget conteudo;

  /// Widget fixo no rodapé acima do footer (ex: medidor de risco
  /// + bottom bar de navegação).
  final Widget? rodapeFixo;

  /// Callback de saída rápida. Default: imprime no console; será
  /// substituído pelo helper web na Fase 6.
  final AoSairCallback aoSair;

  /// Se o conteúdo deve ser limitado à largura máxima padrão.
  final bool limitarLarguraConteudo;

  /// Padding extra ao redor do conteúdo.
  final EdgeInsetsGeometry padding;

  /// Controller opcional do scroll externo da página.
  ///
  /// Quando informado, o ScaffoldAcolhedor vincula seu SingleChildScrollView
  /// a este controller — útil para a página resetar o scroll programaticamente
  /// (ex.: ao trocar de etapa na Avaliação). Quando null, o scroll é livre.
  final ScrollController? scrollController;

  /// Se o footer deve ser exibido. Em telas onde queremos o conteúdo
  /// preencher a viewport (ex.: Avaliação com bottom bar fixa), esconder
  /// o footer evita scroll inútil e melhora o foco.
  final bool mostrarFooter;

  const ScaffoldAcolhedor({
    super.key,
    required this.conteudo,
    this.rodapeFixo,
    this.aoSair = web.sairRapido,
    this.limitarLarguraConteudo = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimensoes.e16,
      vertical: AppDimensoes.e24,
    ),
    this.scrollController,
    this.mostrarFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget conteudoLimitado = Padding(
      padding: padding,
      child: conteudo,
    );
    if (limitarLarguraConteudo) {
      conteudoLimitado = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensoes.larguraMaximaConteudo,
          ),
          child: conteudoLimitado,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppCores.fundo,
      body: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.escape): _IntencaoSair(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            _IntencaoSair: CallbackAction<_IntencaoSair>(
              onInvoke: (_) async {
                final ctx = context;
                final confirmou = await mostrarConfirmacaoSaidaModal(ctx);
                if (confirmou == true) aoSair();
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            // SafeArea cobre o status bar do dispositivo móvel — sem
            // ele, o relógio/wifi/bateria do sistema operacional
            // ficam sobrepostos ao HeaderApp em telas edge-to-edge
            // (Android com gesto, iOS com notch). bottom: false
            // porque o rodapé fixo (BarraNavegacaoEtapa) já cuida
            // do seu próprio SafeArea inferior.
            child: SafeArea(
              top: true,
              bottom: false,
              left: false,
              right: false,
              child: Column(
                children: [
                  HeaderApp(aoConfirmarSaida: aoSair),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          conteudoLimitado,
                          if (mostrarFooter) const FooterApp(),
                        ],
                      ),
                    ),
                  ),
                  ?rodapeFixo,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Intent simbólica para o atalho ESC. Mantida private dentro do arquivo
/// porque só faz sentido neste contexto.
class _IntencaoSair extends Intent {
  const _IntencaoSair();
}
