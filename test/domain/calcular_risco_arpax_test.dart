// Testes ponta-a-ponta do motor AR PAX.
//
// Estes testes constroem perguntas e respostas em memória (sem depender
// dos JSONs de assets/mock/), o que torna o motor verificável de forma
// totalmente isolada e rápida.
//
// CENÁRIOS COBERTOS:
//   1. Vazio: nenhuma resposta → V=0, A=0 → Muito Baixo.
//   2. Canário do Silvano: P1 + P2(tapa+soco) + P3 → V=2.00 / A=1.167 → MB.
//      (Este é o cenário ouro: bate com a planilha do Felipe Scarpelli.)
//   3. Máximo teórico: marcações saturadas em todos os critérios →
//      V≈5.42, A≈9.17 → Extremo.
//   4. Saturação: marcar acima do teto não infla mais o nível.
//   5. Apenas Vulnerabilidade alta: vítima com perfil de risco mas
//      sem agressor identificado → MO/AL conforme matriz.

import 'package:flutter_test/flutter_test.dart';
import 'package:desperte_mulher/domain/entities/criterio_arpax.dart';
import 'package:desperte_mulher/domain/entities/grau_risco.dart';
import 'package:desperte_mulher/domain/entities/nivel_dimensao.dart';
import 'package:desperte_mulher/domain/entities/opcao_resposta.dart';
import 'package:desperte_mulher/domain/entities/pergunta.dart';
import 'package:desperte_mulher/domain/entities/resposta_usuaria.dart';
import 'package:desperte_mulher/domain/usecases/calcular_risco_arpax.dart';

// ── Helpers de construção de perguntas ────────────────────────────────

/// Cria uma pergunta de escolha única com N opções positivas + 1 "Não".
Pergunta _perguntaUnica({
  required String id,
  required Set<CriterioArpax> criterios,
  int positivas = 1,
}) {
  return Pergunta(
    id: id,
    numero: id,
    texto: 'pergunta $id',
    modo: ModoSelecao.unica,
    criteriosAlimentados: criterios,
    opcoes: [
      ...List.generate(
        positivas,
        (i) => OpcaoResposta(texto: 'Sim opção $i'),
      ),
      const OpcaoResposta(texto: 'Não', ehNegativa: true),
    ],
  );
}

/// Cria uma pergunta de múltipla escolha com N opções positivas + 1 negativa.
Pergunta _perguntaMultipla({
  required String id,
  required Set<CriterioArpax> criterios,
  required int positivas,
}) {
  return Pergunta(
    id: id,
    numero: id,
    texto: 'pergunta $id',
    modo: ModoSelecao.multipla,
    criteriosAlimentados: criterios,
    opcoes: [
      ...List.generate(
        positivas,
        (i) => OpcaoResposta(texto: 'Opção positiva $i'),
      ),
      const OpcaoResposta(texto: 'Nenhuma', ehNegativa: true),
    ],
  );
}

void main() {
  const motor = CalcularRiscoArpax();

  group('Cenário 1 — vazio', () {
    test('Sem respostas → V=0, A=0, Muito Baixo', () {
      final r = motor.calcular(respostas: {}, perguntas: {});

      expect(r.vulnerabilidadeFinal, 0.0);
      expect(r.ameacaFinal, 0.0);
      expect(r.nivelVulnerabilidade, NivelVulnerabilidade.muitoBaixa);
      expect(r.nivelAmeaca, NivelAmeaca.insignificante);
      expect(r.grauFinal, GrauRisco.muitoBaixo);
    });
  });

  group('Cenário 2 — canário do Silvano (P1+P2tapa+soco+P3 → MB)', () {
    // NOTA: o doc 01_COMPILACAO seção 4.7 tem uma divergência interna
    // com a tabela de mapeamento da seção 6 (autoritativa). A seção 4.7
    // diz que P3 alimenta só {VC2, AC2}; a seção 6 diz {VC2, VC3, AC2}.
    // Seguimos a seção 6 (autoritativa). O resultado final coincide:
    // VC3=3→nível 2 (4.7) ou VC3=4→nível 2 (seção 6), nos dois casos a
    // faixa 3-5 da Casuística dá nível 2 (Baixa), V_final=2.00 e A=1.167.
    //
    // P1 alimenta {VC2, VC3, AC2, AC3} — 1 opção positiva ("Sim, arma de fogo")
    // P2 alimenta {VC2, VC3, AC2, AC3} — 2 opções positivas (tapa + soco)
    // P3 alimenta {VC2, VC3, AC2}      — 1 opção positiva ("Sim, atendimento médico")
    //
    // Marcações esperadas (seção 6 do doc):
    //   VC2: 1 + 2 + 1 = 4    → nível 3 (Média, faixa 4)
    //   VC3: 1 + 2 + 1 = 4    → nível 2 (Baixa,  faixa 3-5)
    //   AC2: 1 + 2 + 1 = 4    → nível 2 (Pequena, faixa 3-5)
    //   AC3: 1 + 2 + 0 = 3    → nível 1 (Insignif., faixa 1-3)
    //
    // V_final = 3×(1/2) + 2×(1/4) + 0×(1/3) = 1.5 + 0.5 + 0 = 2.00 → Baixa
    // A_final = 0×1     + 2×(1/3) + 1×(1/2) = 0 + 0.667 + 0.5 = 1.167 → Insignif.
    //
    // Matriz: Baixa × Insignificante = MB (Muito Baixo)

    final p1 = _perguntaUnica(
      id: 'P1',
      criterios: {
        CriterioArpax.exposicao,
        CriterioArpax.casuistica,
        CriterioArpax.historico,
        CriterioArpax.tendencia,
      },
    );
    final p2 = _perguntaMultipla(
      id: 'P2',
      criterios: {
        CriterioArpax.exposicao,
        CriterioArpax.casuistica,
        CriterioArpax.historico,
        CriterioArpax.tendencia,
      },
      positivas: 14, // P2 real tem 14 opções positivas
    );
    final p3 = _perguntaUnica(
      id: 'P3',
      criterios: {
        CriterioArpax.exposicao,
        CriterioArpax.casuistica,
        CriterioArpax.historico,
      },
      positivas: 2, // P3 real tem "Sim, médico" e "Sim, internação"
    );

    final perguntas = {p1.id: p1, p2.id: p2, p3.id: p3};

    // Marca a 1ª opção positiva de P1, as 2 primeiras de P2 (tapa+soco),
    // a 1ª de P3 (atendimento médico).
    final respostas = {
      'P1': const RespostaUsuaria(idPergunta: 'P1', indicesMarcados: [0]),
      'P2': const RespostaUsuaria(idPergunta: 'P2', indicesMarcados: [0, 1]),
      'P3': const RespostaUsuaria(idPergunta: 'P3', indicesMarcados: [0]),
    };

    final r = motor.calcular(respostas: respostas, perguntas: perguntas);

    test('Marcações batem com a tabela autoritativa (seção 6)', () {
      expect(r.marcacoesPorCriterio[CriterioArpax.exposicao], 4);
      expect(r.marcacoesPorCriterio[CriterioArpax.casuistica], 4);
      expect(r.marcacoesPorCriterio[CriterioArpax.historico], 4);
      expect(r.marcacoesPorCriterio[CriterioArpax.tendencia], 3);
      expect(r.marcacoesPorCriterio[CriterioArpax.atratibilidade], 0);
      expect(r.marcacoesPorCriterio[CriterioArpax.motivacao], 0);
    });

    test('Níveis Likert batem com a planilha', () {
      expect(r.niveisPorCriterio[CriterioArpax.exposicao], 3); // 4 → Média
      expect(r.niveisPorCriterio[CriterioArpax.casuistica], 2); // 3 → Baixa
      expect(r.niveisPorCriterio[CriterioArpax.historico], 2); // 4 → Pequena
      expect(r.niveisPorCriterio[CriterioArpax.tendencia], 1); // 3 → Insignif.
    });

    test('V_final = 2.00 (Baixa)', () {
      expect(r.vulnerabilidadeFinal, closeTo(2.0, 0.01));
      expect(r.nivelVulnerabilidade, NivelVulnerabilidade.baixa);
    });

    test('A_final = 1.167 (Insignificante)', () {
      expect(r.ameacaFinal, closeTo(1.167, 0.01));
      expect(r.nivelAmeaca, NivelAmeaca.insignificante);
    });

    test('Grau final = Muito Baixo (canário do Silvano)', () {
      expect(r.grauFinal, GrauRisco.muitoBaixo);
    });
  });

  group('Cenário 3 — máximo teórico (saturação total)', () {
    // Fabrica uma pergunta absurda que satura TODOS os critérios.
    // Marca opções suficientes para todos os contadores estourarem o
    // nível 5 — o que prova que V_max=5.42 e A_max=9.17.
    test('V≈5.42 e A≈9.17 → Extremo', () {
      final perguntaSatura = Pergunta(
        id: 'PSAT',
        numero: 'sat',
        texto: 'saturação',
        modo: ModoSelecao.multipla,
        criteriosAlimentados: CriterioArpax.values.toSet(),
        opcoes: List.generate(
          20,
          (i) => OpcaoResposta(texto: 'opção $i'),
        ),
      );
      // Marca todas as 20 → cada critério recebe 20 marcações (saturado em 5)
      final resp = {
        'PSAT': RespostaUsuaria(
          idPergunta: 'PSAT',
          indicesMarcados: List.generate(20, (i) => i),
        ),
      };
      final r = motor.calcular(
        respostas: resp,
        perguntas: {'PSAT': perguntaSatura},
      );

      // Todos os critérios devem ter nível 5
      for (final c in CriterioArpax.values) {
        expect(r.niveisPorCriterio[c], 5, reason: '${c.sigla} saturado');
      }

      expect(r.vulnerabilidadeFinal, closeTo(5.4166, 0.01));
      expect(r.ameacaFinal, closeTo(9.1666, 0.01));
      expect(r.nivelVulnerabilidade, NivelVulnerabilidade.muitoAlta);
      expect(r.nivelAmeaca, NivelAmeaca.extrema);
      expect(r.grauFinal, GrauRisco.extremo);
    });
  });

  group('Cenário 4 — opções negativas não contam', () {
    test('Marcar só "Não" deve produzir grau Muito Baixo', () {
      final p = _perguntaUnica(
        id: 'PNEG',
        criterios: {CriterioArpax.exposicao, CriterioArpax.historico},
      );
      // Última opção é "Não" (ehNegativa=true) — não conta.
      final indicePNAO = p.opcoes.length - 1;
      final r = motor.calcular(
        respostas: {
          'PNEG': RespostaUsuaria(idPergunta: 'PNEG', indicesMarcados: [indicePNAO]),
        },
        perguntas: {'PNEG': p},
      );
      expect(r.vulnerabilidadeFinal, 0.0);
      expect(r.ameacaFinal, 0.0);
      expect(r.grauFinal, GrauRisco.muitoBaixo);
    });
  });

  group('Cenário 5 — Vulnerabilidade alta, Ameaça baixa', () {
    // Vítima cujo perfil tem fatores de vulnerabilidade altos
    // (gravidez, deficiência, dependência, etc) mas sem agressor
    // identificado. Apenas Atratibilidade pode chegar a 5 com 7
    // marcações; com 3 marcações vai a Baixa.
    test('Apenas VC1 com 7 marcações → V ≈ 1.667 (Baixa), A=0 → MB', () {
      final p = Pergunta(
        id: 'PVC1',
        numero: 'vc1',
        texto: 'perfil',
        modo: ModoSelecao.multipla,
        criteriosAlimentados: {CriterioArpax.atratibilidade},
        opcoes: List.generate(7, (i) => OpcaoResposta(texto: 'fator $i')),
      );
      final r = motor.calcular(
        respostas: {
          'PVC1': RespostaUsuaria(
            idPergunta: 'PVC1',
            indicesMarcados: List.generate(7, (i) => i),
          ),
        },
        perguntas: {'PVC1': p},
      );

      // VC1 com 7 marcações → nível 5 (Muito Alta)
      expect(r.niveisPorCriterio[CriterioArpax.atratibilidade], 5);
      // V_final = 5 × 1/3 = 1.667 → Baixa (1.10-2.21)
      expect(r.vulnerabilidadeFinal, closeTo(5 / 3, 0.01));
      expect(r.nivelVulnerabilidade, NivelVulnerabilidade.baixa);
      expect(r.nivelAmeaca, NivelAmeaca.insignificante);
      // Baixa × Insignificante = MB
      expect(r.grauFinal, GrauRisco.muitoBaixo);
    });
  });

  group('Cenário 6 — robustez', () {
    test('Resposta com id de pergunta inexistente é ignorada', () {
      final r = motor.calcular(
        respostas: {
          'FANTASMA': const RespostaUsuaria(
            idPergunta: 'FANTASMA',
            indicesMarcados: [0, 1, 2],
          ),
        },
        perguntas: {}, // nenhuma pergunta cadastrada
      );
      expect(r.grauFinal, GrauRisco.muitoBaixo);
    });

    test('Índices fora do range são ignorados (não quebra)', () {
      final p = _perguntaUnica(
        id: 'P',
        criterios: {CriterioArpax.exposicao},
      );
      final r = motor.calcular(
        respostas: {
          'P': const RespostaUsuaria(
            idPergunta: 'P',
            indicesMarcados: [99, -3],
          ),
        },
        perguntas: {'P': p},
      );
      expect(r.grauFinal, GrauRisco.muitoBaixo);
    });
  });
}
