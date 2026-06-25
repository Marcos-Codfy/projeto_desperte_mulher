// Card grande colorido que mostra o grau final na tela de Resultado.
// A cor varia conforme o grau (verde-sálvia para MB, bordô maduro para EX).

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/domain/entities/grau_risco.dart';
import 'package:desperte_mulher/domain/entities/resultado_arpax.dart';

class CardResultado extends StatelessWidget {
  final ResultadoArpax resultado;

  const CardResultado({super.key, required this.resultado});

  Color _cor() {
    switch (resultado.grauFinal) {
      case GrauRisco.muitoBaixo:
        return AppCores.grauMuitoBaixo;
      case GrauRisco.baixo:
        return AppCores.grauBaixo;
      case GrauRisco.moderado:
        return AppCores.grauModerado;
      case GrauRisco.alto:
        return AppCores.grauAlto;
      case GrauRisco.extremo:
        return AppCores.grauExtremo;
    }
  }

  IconData _icone() {
    switch (resultado.grauFinal) {
      case GrauRisco.muitoBaixo:
      case GrauRisco.baixo:
        return Icons.eco_outlined;
      case GrauRisco.moderado:
        return Icons.shield_moon_outlined;
      case GrauRisco.alto:
        return Icons.warning_amber_outlined;
      case GrauRisco.extremo:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cor = _cor();

    return Semantics(
      label:
          'Grau de risco: ${resultado.grauFinal.label}. Vulnerabilidade: ${resultado.nivelVulnerabilidade.label}. Ameaça: ${resultado.nivelAmeaca.label}.',
      child: Container(
        padding: const EdgeInsets.all(AppDimensoes.e24),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(AppDimensoes.raioGrande),
          boxShadow: AppSombras.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icone(), size: 32, color: Colors.white),
                const SizedBox(width: AppDimensoes.e12),
                Expanded(
                  child: Text(
                    'Grau: ${resultado.grauFinal.label}',
                    style: AppTipografia.tituloH1.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensoes.e16),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.4)),
            const SizedBox(height: AppDimensoes.e16),
            _Linha(
              rotulo: AppStrings.resultadoVulnerabilidadeLabel,
              valor: resultado.nivelVulnerabilidade.label,
            ),
            const SizedBox(height: AppDimensoes.e8),
            _Linha(
              rotulo: AppStrings.resultadoAmeacaLabel,
              valor: resultado.nivelAmeaca.label,
            ),
            const SizedBox(height: AppDimensoes.e16),
            Text(
              resultado.grauFinal.microcopyAcolhedor,
              style: AppTipografia.corpo.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _Linha extends StatelessWidget {
  final String rotulo;
  final String valor;
  const _Linha({required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$rotulo: ',
          style: AppTipografia.corpo.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        Text(
          valor,
          style: AppTipografia.corpo.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
