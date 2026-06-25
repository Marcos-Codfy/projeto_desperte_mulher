// Fonte de dados local — lê as 5 etapas de assets/mock/etapa_N.json.
//
// Simula latência de rede (Future.delayed) para que a UI já nasça
// preparada para esperar pelo backend real quando ele estiver pronto.
// Sem isso, eu teria que adicionar loading states depois.

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'package:desperte_mulher/data/models/etapa_dto.dart';

class QuizLocalDataSource {
  const QuizLocalDataSource({
    Duration delaySimulado = const Duration(milliseconds: 600),
  }) : _delay = delaySimulado;

  final Duration _delay;

  /// Carrega uma etapa específica (1..5).
  /// Lança [ArgumentError] se [numeroEtapa] estiver fora da faixa.
  Future<EtapaDto> carregarEtapa(int numeroEtapa) async {
    if (numeroEtapa < 1 || numeroEtapa > 5) {
      throw ArgumentError.value(
        numeroEtapa,
        'numeroEtapa',
        'Etapa deve estar entre 1 e 5',
      );
    }
    await Future<void>.delayed(_delay);
    final caminho = 'assets/mock/etapa_$numeroEtapa.json';
    final jsonString = await rootBundle.loadString(caminho);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return EtapaDto.fromJson(json);
  }
}
