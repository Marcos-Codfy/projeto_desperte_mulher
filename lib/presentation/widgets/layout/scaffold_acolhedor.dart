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

  /// Widget fixo no rodapé acima do footer (ex: medidor de risco).
  final Widget? rodapeFixo;

  /// Callback de saída rápida. Default: imprime no console; será
  /// substituído pelo helper web na Fase 6.
  final AoSairCallback aoSair;

  /// Se o conteúdo deve ser limitado à largura máxima padrão.
  final bool limitarLarguraConteudo;

  /// Padding extra ao redor do conteúdo.
  final EdgeInsetsGeometry padding;

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
            child: Column(
              children: [
                HeaderApp(aoConfirmarSaida: aoSair),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        conteudoLimitado,
                        const FooterApp(),
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
    );
  }
}

/// Intent simbólica para o atalho ESC. Mantida private dentro do arquivo
/// porque só faz sentido neste contexto.
class _IntencaoSair extends Intent {
  const _IntencaoSair();
}
