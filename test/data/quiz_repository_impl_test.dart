// Testes da camada data: garante que os 5 JSONs estão bem-formados,
// que o mapper consegue convertê-los todos sem erro, e que o número
// de perguntas em cada etapa bate com o planejado.
//
// Estes testes são a primeira linha de defesa contra typos no JSON
// (chave de critério escrita errada, modo desconhecido, etc).

import 'package:flutter_test/flutter_test.dart';

import 'package:desperte_mulher/data/repositories/quiz_repository_impl.dart';
import 'package:desperte_mulher/data/datasources/quiz_local_datasource.dart';
import 'package:desperte_mulher/domain/entities/pergunta.dart';

void main() {
  // Necessário para usar rootBundle dentro de testes.
  TestWidgetsFlutterBinding.ensureInitialized();

  // Datasource sem delay para acelerar testes.
  final repo = QuizRepositoryImpl(
    datasource: const QuizLocalDataSource(delaySimulado: Duration.zero),
  );

  group('Leitura dos 5 JSONs', () {
    test('Etapa 1 tem 5 perguntas (P1..P5)', () async {
      final etapa = await repo.carregarEtapa(1);
      expect(etapa.numero, 1);
      expect(etapa.perguntas.length, 5);
      expect(etapa.perguntas.first.id, 'P1');
      expect(etapa.perguntas.last.id, 'P5');
    });

    test('Etapa 2 tem 8 perguntas (P6, P7a, P7b, P8..P12)', () async {
      final etapa = await repo.carregarEtapa(2);
      expect(etapa.perguntas.length, 8);
      final ids = etapa.perguntas.map((p) => p.id).toList();
      expect(ids, ['P6', 'P7a', 'P7b', 'P8', 'P9', 'P10', 'P11', 'P12']);
    });

    test('Etapa 3 tem 6 perguntas (P13..P16c)', () async {
      final etapa = await repo.carregarEtapa(3);
      expect(etapa.perguntas.length, 6);
      final ids = etapa.perguntas.map((p) => p.id).toList();
      expect(ids, ['P13', 'P14', 'P15', 'P16a', 'P16b', 'P16c']);
    });

    test('Etapa 4 tem 5 perguntas (P17..P21)', () async {
      final etapa = await repo.carregarEtapa(4);
      expect(etapa.perguntas.length, 5);
    });

    test('Etapa 5 tem 6 perguntas (P22..P27)', () async {
      final etapa = await repo.carregarEtapa(5);
      expect(etapa.perguntas.length, 6);
    });

    test('carregarTodas devolve as 5 etapas em ordem', () async {
      final etapas = await repo.carregarTodas();
      expect(etapas.length, 5);
      for (var i = 0; i < 5; i++) {
        expect(etapas[i].numero, i + 1);
      }
    });
  });

  group('Integridade do conteúdo', () {
    test('Total de perguntas = 30 (27 FONAR com subitens)', () async {
      final etapas = await repo.carregarTodas();
      final total = etapas.fold<int>(0, (sum, e) => sum + e.perguntas.length);
      expect(total, 30);
    });

    test('Todos os ids são únicos (sem duplicata)', () async {
      final etapas = await repo.carregarTodas();
      final ids = <String>[];
      for (final e in etapas) {
        ids.addAll(e.perguntas.map((p) => p.id));
      }
      expect(ids.toSet().length, ids.length, reason: 'duplicatas: $ids');
    });

    test('Perguntas com múltiplas opções (2, 6, 14) têm modo "multipla"',
        () async {
      final etapas = await repo.carregarTodas();
      Pergunta porId(String id) =>
          etapas.expand((e) => e.perguntas).firstWhere((p) => p.id == id);

      expect(porId('P2').modo, ModoSelecao.multipla);
      expect(porId('P6').modo, ModoSelecao.multipla);
      expect(porId('P14').modo, ModoSelecao.multipla);
      // P16b também é multipla
      expect(porId('P16b').modo, ModoSelecao.multipla);
    });

    test('Pergunta 2 mantém 15 opções (14 positivas + "Nenhuma")', () async {
      final etapas = await repo.carregarTodas();
      final p2 =
          etapas.expand((e) => e.perguntas).firstWhere((p) => p.id == 'P2');
      expect(p2.opcoes.length, 15);
      expect(p2.opcoes.last.ehNegativa, true);
      expect(p2.opcoes.last.texto, 'Nenhuma agressão física');
    });

    test('Pergunta 1 alimenta {VC2, VC3, AC2, AC3} (mapeamento seção 6)',
        () async {
      final etapas = await repo.carregarTodas();
      final p1 =
          etapas.expand((e) => e.perguntas).firstWhere((p) => p.id == 'P1');
      final siglas = p1.criteriosAlimentados.map((c) => c.sigla).toSet();
      expect(siglas, {'VC2', 'VC3', 'AC2', 'AC3'});
    });
  });
}
