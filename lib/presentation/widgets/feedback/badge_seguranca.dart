// Chip simples com ícone + texto. Usado para comunicar garantias da
// plataforma à usuária ("100% anônimo", "Gratuito", "Base científica").

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class BadgeSeguranca extends StatelessWidget {
  final String texto;
  final IconData icone;
  final Color? corFundo;
  final Color? corTexto;

  const BadgeSeguranca({
    super.key,
    required this.texto,
    required this.icone,
    this.corFundo,
    this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    final fundo = corFundo ?? AppCores.primariaFundo;
    final texto_ = corTexto ?? AppCores.primariaEscura;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e12,
        vertical: AppDimensoes.e8,
      ),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(AppDimensoes.raioPilula),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 16, color: texto_),
          const SizedBox(width: AppDimensoes.e8),
          Text(
            texto,
            style: AppTipografia.corpoPequeno.copyWith(
              color: texto_,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
