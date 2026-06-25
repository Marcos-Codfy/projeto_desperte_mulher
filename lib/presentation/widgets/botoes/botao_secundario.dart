// Botão secundário (borda lavanda, fundo transparente). Usado em ações
// de menor peso (Voltar, Cancelar, Tenho dúvidas).

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'botao_primario.dart' show TamanhoBotao;

class BotaoSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback? aoPressionar;
  final TamanhoBotao tamanho;
  final IconData? icone;
  final bool largura100;

  const BotaoSecundario({
    super.key,
    required this.texto,
    required this.aoPressionar,
    this.tamanho = TamanhoBotao.medio,
    this.icone,
    this.largura100 = false,
  });

  double get _altura {
    switch (tamanho) {
      case TamanhoBotao.pequeno:
        return AppDimensoes.alturaBotaoPequeno;
      case TamanhoBotao.medio:
        return AppDimensoes.alturaBotaoMedio;
      case TamanhoBotao.grande:
        return AppDimensoes.alturaBotaoGrande;
    }
  }

  EdgeInsetsGeometry get _padding {
    switch (tamanho) {
      case TamanhoBotao.pequeno:
        return const EdgeInsets.symmetric(horizontal: AppDimensoes.e16);
      case TamanhoBotao.medio:
        return const EdgeInsets.symmetric(horizontal: AppDimensoes.e24);
      case TamanhoBotao.grande:
        return const EdgeInsets.symmetric(horizontal: AppDimensoes.e32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filhos = <Widget>[];
    if (icone != null) {
      filhos.add(Icon(icone, size: 18, color: AppCores.primaria));
      filhos.add(const SizedBox(width: AppDimensoes.e8));
    }
    filhos.add(Text(
      texto,
      style: AppTipografia.botao.copyWith(color: AppCores.primaria),
    ));

    final botao = SizedBox(
      height: _altura,
      child: OutlinedButton(
        onPressed: aoPressionar,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppCores.primaria,
          side: const BorderSide(color: AppCores.primaria, width: 1.5),
          padding: _padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
          ),
        ),
        child: Row(
          mainAxisSize: largura100 ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: filhos,
        ),
      ),
    );

    return largura100 ? SizedBox(width: double.infinity, child: botao) : botao;
  }
}
