// Botão primário (lavanda preenchido). Usado em CTAs principais.
//
// Tamanhos: pequeno (40), médio (48), grande (56). Default é médio.
// Mostra um spinner branco no centro quando aoPressionar = null com
// indicador de loading externo (futuro), por enquanto o "loading" é
// expressado mostrando opaco e sem cliques.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';

enum TamanhoBotao { pequeno, medio, grande }

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback? aoPressionar;
  final TamanhoBotao tamanho;
  final IconData? icone;
  final bool carregando;
  final bool largura100;

  const BotaoPrimario({
    super.key,
    required this.texto,
    required this.aoPressionar,
    this.tamanho = TamanhoBotao.medio,
    this.icone,
    this.carregando = false,
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
    final habilitado = aoPressionar != null && !carregando;

    final filhos = <Widget>[];
    if (carregando) {
      filhos.add(const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ));
    } else {
      if (icone != null) {
        filhos.add(Icon(icone, size: 18, color: Colors.white));
        filhos.add(const SizedBox(width: AppDimensoes.e8));
      }
      filhos.add(Text(texto, style: AppTipografia.botao.copyWith(color: Colors.white)));
    }

    final botao = SizedBox(
      height: _altura,
      child: ElevatedButton(
        onPressed: habilitado ? aoPressionar : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,
          disabledBackgroundColor: AppCores.primariaClara,
          elevation: 0,
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
