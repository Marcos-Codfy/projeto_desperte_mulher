// Botão de texto (sem fundo, sem borda). Para links em prosa
// ("ler termos", "saber mais") e ações de baixa hierarquia.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_theme.dart';

class BotaoTexto extends StatelessWidget {
  final String texto;
  final VoidCallback? aoPressionar;
  final IconData? icone;

  const BotaoTexto({
    super.key,
    required this.texto,
    required this.aoPressionar,
    this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: aoPressionar,
      icon: icone != null
          ? Icon(icone, size: 16, color: AppCores.primaria)
          : const SizedBox.shrink(),
      label: Text(
        texto,
        style: AppTipografia.botao.copyWith(color: AppCores.primaria),
      ),
      style: TextButton.styleFrom(foregroundColor: AppCores.primaria),
    );
  }
}
