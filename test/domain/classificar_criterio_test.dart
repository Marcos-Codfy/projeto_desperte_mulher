// Testa a função CriterioArpax.classificarLikert exaustivamente.
//
// Cobre:
//   - Saturação (acima do teto, nível continua sendo 5)
//   - Marcações <= 0 retornam 0 ("critério não acionado")
//   - Bordas de cada faixa
//
// Esses testes são baratos (são puros Dart) e protegem contra
// regressões se alguém um dia "limpar" a função.

import 'package:flutter_test/flutter_test.dart';
import 'package:desperte_mulher/domain/entities/criterio_arpax.dart';

void main() {
  group('classificarLikert — marcações ≤ 0 ', () {
    test('Todos os critérios retornam 0 quando marcações = 0', () {
      for (final c in CriterioArpax.values) {
        expect(c.classificarLikert(0), 0, reason: '${c.sigla} com 0 marcações');
        expect(c.classificarLikert(-3), 0, reason: '${c.sigla} negativo');
      }
    });
  });

  group('Atratibilidade (VC1, teto=7)', () {
    final c = CriterioArpax.atratibilidade;

    test('1 marcação → Muito Baixa (1)', () => expect(c.classificarLikert(1), 1));
    test('2 e 3 → Baixa (2)', () {
      expect(c.classificarLikert(2), 2);
      expect(c.classificarLikert(3), 2);
    });
    test('4 → Média (3)', () => expect(c.classificarLikert(4), 3));
    test('5 e 6 → Alta (4)', () {
      expect(c.classificarLikert(5), 4);
      expect(c.classificarLikert(6), 4);
    });
    test('7 → Muito Alta (5)', () => expect(c.classificarLikert(7), 5));
    test('saturação: 10 → 5', () => expect(c.classificarLikert(10), 5));
  });

  group('Exposição (VC2, teto=8)', () {
    final c = CriterioArpax.exposicao;
    test('1 → 1, 4 → 3, 8 → 5', () {
      expect(c.classificarLikert(1), 1);
      expect(c.classificarLikert(4), 3);
      expect(c.classificarLikert(8), 5);
    });
    test('saturação: 20 → 5', () => expect(c.classificarLikert(20), 5));
  });

  group('Casuística (VC3, teto=14) — exemplo do planejamento', () {
    final c = CriterioArpax.casuistica;
    test('Tabela da seção 4.2', () {
      expect(c.classificarLikert(2), 1);
      expect(c.classificarLikert(5), 2);
      expect(c.classificarLikert(7), 3);
      expect(c.classificarLikert(10), 4);
      expect(c.classificarLikert(11), 5);
      expect(c.classificarLikert(14), 5);
    });
    test('saturação: 20 → 5 (não infla acima)', () {
      expect(c.classificarLikert(20), 5);
    });
  });

  group('Motivação (AC1, teto=12)', () {
    final c = CriterioArpax.motivacao;
    test('Tabela', () {
      expect(c.classificarLikert(2), 1);
      expect(c.classificarLikert(5), 2);
      expect(c.classificarLikert(7), 3);
      expect(c.classificarLikert(10), 4);
      expect(c.classificarLikert(12), 5);
    });
  });

  group('Histórico (AC2, teto=14)', () {
    final c = CriterioArpax.historico;
    test('Tabela', () {
      expect(c.classificarLikert(1), 1);
      expect(c.classificarLikert(5), 2);
      expect(c.classificarLikert(7), 3);
      expect(c.classificarLikert(10), 4);
      expect(c.classificarLikert(14), 5);
    });
  });

  group('Tendência (AC3, teto=16) — escala diferente', () {
    final c = CriterioArpax.tendencia;
    test('Tabela', () {
      expect(c.classificarLikert(3), 1);
      expect(c.classificarLikert(6), 2);
      expect(c.classificarLikert(9), 3);
      expect(c.classificarLikert(12), 4);
      expect(c.classificarLikert(13), 5);
      expect(c.classificarLikert(16), 5);
    });
  });

  group('Pesos — bate com o quadro 7 (V_max=5.42, A_max=9.17)', () {
    test('Soma de pesos VC = 13/12 (Vulnerabilidade)', () {
      final somaVC = CriterioArpax.atratibilidade.peso +
          CriterioArpax.exposicao.peso +
          CriterioArpax.casuistica.peso;
      expect(somaVC, closeTo(13 / 12, 1e-9));
      // V_max = 5 × 13/12 = 5.4166…
      expect(5 * somaVC, closeTo(5.4166, 0.01));
    });
    test('Soma de pesos AC = 11/6 (Ameaça)', () {
      final somaAC = CriterioArpax.motivacao.peso +
          CriterioArpax.historico.peso +
          CriterioArpax.tendencia.peso;
      expect(somaAC, closeTo(11 / 6, 1e-9));
      // A_max = 5 × 11/6 = 9.1666…
      expect(5 * somaAC, closeTo(9.1666, 0.01));
    });
  });
}
