// Indicador "Etapa 2 de 5" com 5 círculos conectados por linhas.
//
// Estados de cada círculo:
//   - Concluído  → preenchido com cor primária + ícone de check
//   - Atual      → preenchido com primária + número
//   - Pendente   → contorno cinza + número apagado

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class ProgressoEtapas extends StatelessWidget {
  /// 1-based: 1 = primeira etapa. Aceita valores de 1 a [totalEtapas].
  final int etapaAtual;
  final int totalEtapas;

  const ProgressoEtapas({
    super.key,
    required this.etapaAtual,
    required this.totalEtapas,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${AppStrings.avaliacaoEtapaLabel} $etapaAtual ${AppStrings.avaliacaoDe} $totalEtapas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.avaliacaoEtapaLabel} $etapaAtual ${AppStrings.avaliacaoDe} $totalEtapas',
            style: AppTipografia.corpoPequeno.copyWith(
              color: AppCores.primariaEscura,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensoes.e8),
          Row(
            children: List.generate(
              totalEtapas * 2 - 1,
              (i) {
                final ehCirculo = i.isEven;
                if (ehCirculo) {
                  final numero = (i ~/ 2) + 1;
                  return _circulo(numero);
                }
                final etapaAnterior = (i ~/ 2) + 1;
                return Expanded(child: _linha(etapaAnterior < etapaAtual));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _circulo(int numero) {
    final concluida = numero < etapaAtual;
    final atual = numero == etapaAtual;
    final corFundo = concluida || atual
        ? AppCores.primaria
        : AppCores.fundoCard;
    final corBorda = concluida || atual
        ? AppCores.primaria
        : AppCores.divisor;
    final corTexto = concluida || atual ? Colors.white : AppCores.textoApagado;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: corFundo,
        shape: BoxShape.circle,
        border: Border.all(color: corBorda, width: 2),
      ),
      alignment: Alignment.center,
      child: concluida
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              '$numero',
              style: AppTipografia.corpoPequeno.copyWith(
                color: corTexto,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }

  Widget _linha(bool ativa) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensoes.e4),
      color: ativa ? AppCores.primaria : AppCores.divisor,
    );
  }
}
