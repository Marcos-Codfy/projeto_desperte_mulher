// Indicador de progresso da Avaliação.
//
// Composto por:
//   1. Cabeçalho com label "Etapa X de 5 · faltam ~Y min"
//   2. Barra linear preenchida proporcionalmente à etapa atual
//   3. Cinco círculos conectados por linhas (check / número / contorno)
//
// Estados de cada círculo:
//   - Concluído  → preenchido com cor primária + ícone de check
//   - Atual      → preenchido com primária + número
//   - Pendente   → contorno cinza + número apagado
//
// O label de tempo serve a UX: previsibilidade reduz ansiedade e
// abandono em avaliações sensíveis. Estimativa conservadora de
// ~3 min por etapa (15 min totais).

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class ProgressoEtapas extends StatelessWidget {
  /// 1-based: 1 = primeira etapa. Aceita valores de 1 a [totalEtapas].
  final int etapaAtual;
  final int totalEtapas;

  /// Quanto tempo estimamos por etapa.
  /// Usado pelo label "faltam ~Y min".
  final int minutosPorEtapa;

  const ProgressoEtapas({
    super.key,
    required this.etapaAtual,
    required this.totalEtapas,
    this.minutosPorEtapa = 3,
  });

  int get _minutosRestantes {
    final etapasRestantes = (totalEtapas - etapaAtual + 1).clamp(0, totalEtapas);
    return etapasRestantes * minutosPorEtapa;
  }

  double get _percentual {
    if (totalEtapas <= 0) return 0;
    // Progresso conta a etapa atual como "metade feita" — feedback mais
    // generoso, evita a sensação de "ainda não fiz nada" na etapa 1.
    return ((etapaAtual - 0.5) / totalEtapas).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final labelEtapa =
        '${AppStrings.avaliacaoEtapaLabel} $etapaAtual ${AppStrings.avaliacaoDe} $totalEtapas';
    final labelTempo =
        '${AppStrings.avaliacaoFaltam} ~$_minutosRestantes ${AppStrings.avaliacaoMinAbreviado}';

    return Semantics(
      label: '$labelEtapa · $labelTempo',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labelEtapa,
                style: AppTipografia.corpoPequeno.copyWith(
                  color: AppCores.primariaEscura,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                labelTempo,
                style: AppTipografia.corpoPequeno.copyWith(
                  color: AppCores.textoSecundario,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensoes.e8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensoes.raioPilula),
            child: LinearProgressIndicator(
              value: _percentual,
              minHeight: 6,
              backgroundColor: AppCores.divisor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppCores.primaria),
            ),
          ),
          const SizedBox(height: AppDimensoes.e12),
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: corFundo,
        shape: BoxShape.circle,
        border: Border.all(color: corBorda, width: 2),
      ),
      alignment: Alignment.center,
      child: concluida
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : Text(
              '$numero',
              style: AppTipografia.corpoPequeno.copyWith(
                color: corTexto,
                fontWeight: FontWeight.w700,
                fontSize: 12,
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
