// Testa exaustivamente a matriz 5×5 da AR PAX.
//
// 1. Os 25 cruzamentos têm que estar definidos (sem null).
// 2. As linhas e colunas têm que bater com o Quadro 8 do artigo.
// 3. Bordas das faixas (V=1.09 vs 1.10, A=1.32 vs 1.33) classificam certo.

import 'package:flutter_test/flutter_test.dart';
import 'package:desperte_mulher/domain/entities/grau_risco.dart';
import 'package:desperte_mulher/domain/entities/nivel_dimensao.dart';
import 'package:desperte_mulher/domain/usecases/cruzar_matriz_risco.dart';

void main() {
  group('Matriz 5×5 — todos os 25 cruzamentos definidos', () {
    test('cruzarMatriz nunca lança para qualquer combinação válida', () {
      for (final v in NivelVulnerabilidade.values) {
        for (final a in NivelAmeaca.values) {
          expect(
            () => cruzarMatriz(v, a),
            returnsNormally,
            reason: 'V=${v.label}, A=${a.label}',
          );
        }
      }
    });
  });

  group('Matriz 5×5 — linhas individuais conferidas contra o Quadro 8', () {
    // Linha "Muito Baixa": MB MB BA AL AL
    test('Muito Baixa × …', () {
      expect(cruzarMatriz(NivelVulnerabilidade.muitoBaixa, NivelAmeaca.insignificante), GrauRisco.muitoBaixo);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoBaixa, NivelAmeaca.pequena), GrauRisco.muitoBaixo);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoBaixa, NivelAmeaca.moderada), GrauRisco.baixo);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoBaixa, NivelAmeaca.significante), GrauRisco.alto);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoBaixa, NivelAmeaca.extrema), GrauRisco.alto);
    });

    // Linha "Baixa": MB BA MO AL AL
    test('Baixa × …', () {
      expect(cruzarMatriz(NivelVulnerabilidade.baixa, NivelAmeaca.insignificante), GrauRisco.muitoBaixo);
      expect(cruzarMatriz(NivelVulnerabilidade.baixa, NivelAmeaca.pequena), GrauRisco.baixo);
      expect(cruzarMatriz(NivelVulnerabilidade.baixa, NivelAmeaca.moderada), GrauRisco.moderado);
      expect(cruzarMatriz(NivelVulnerabilidade.baixa, NivelAmeaca.significante), GrauRisco.alto);
      expect(cruzarMatriz(NivelVulnerabilidade.baixa, NivelAmeaca.extrema), GrauRisco.alto);
    });

    // Linha "Média": BA BA MO EX EX
    test('Média × …', () {
      expect(cruzarMatriz(NivelVulnerabilidade.media, NivelAmeaca.insignificante), GrauRisco.baixo);
      expect(cruzarMatriz(NivelVulnerabilidade.media, NivelAmeaca.pequena), GrauRisco.baixo);
      expect(cruzarMatriz(NivelVulnerabilidade.media, NivelAmeaca.moderada), GrauRisco.moderado);
      expect(cruzarMatriz(NivelVulnerabilidade.media, NivelAmeaca.significante), GrauRisco.extremo);
      expect(cruzarMatriz(NivelVulnerabilidade.media, NivelAmeaca.extrema), GrauRisco.extremo);
    });

    // Linha "Alta": BA MO AL EX EX
    test('Alta × …', () {
      expect(cruzarMatriz(NivelVulnerabilidade.alta, NivelAmeaca.insignificante), GrauRisco.baixo);
      expect(cruzarMatriz(NivelVulnerabilidade.alta, NivelAmeaca.pequena), GrauRisco.moderado);
      expect(cruzarMatriz(NivelVulnerabilidade.alta, NivelAmeaca.moderada), GrauRisco.alto);
      expect(cruzarMatriz(NivelVulnerabilidade.alta, NivelAmeaca.significante), GrauRisco.extremo);
      expect(cruzarMatriz(NivelVulnerabilidade.alta, NivelAmeaca.extrema), GrauRisco.extremo);
    });

    // Linha "Muito Alta": MO MO AL EX EX
    test('Muito Alta × …', () {
      expect(cruzarMatriz(NivelVulnerabilidade.muitoAlta, NivelAmeaca.insignificante), GrauRisco.moderado);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoAlta, NivelAmeaca.pequena), GrauRisco.moderado);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoAlta, NivelAmeaca.moderada), GrauRisco.alto);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoAlta, NivelAmeaca.significante), GrauRisco.extremo);
      expect(cruzarMatriz(NivelVulnerabilidade.muitoAlta, NivelAmeaca.extrema), GrauRisco.extremo);
    });
  });

  group('Bordas de faixas — V', () {
    test('1.09 ainda é Muito Baixa, 1.10 já é Baixa', () {
      expect(NivelVulnerabilidade.fromValor(1.09), NivelVulnerabilidade.muitoBaixa);
      expect(NivelVulnerabilidade.fromValor(1.10), NivelVulnerabilidade.baixa);
    });
    test('Pontos canônicos das 5 faixas', () {
      expect(NivelVulnerabilidade.fromValor(0.50), NivelVulnerabilidade.muitoBaixa);
      expect(NivelVulnerabilidade.fromValor(2.00), NivelVulnerabilidade.baixa);
      expect(NivelVulnerabilidade.fromValor(3.00), NivelVulnerabilidade.media);
      expect(NivelVulnerabilidade.fromValor(4.00), NivelVulnerabilidade.alta);
      expect(NivelVulnerabilidade.fromValor(5.00), NivelVulnerabilidade.muitoAlta);
      expect(NivelVulnerabilidade.fromValor(5.42), NivelVulnerabilidade.muitoAlta);
    });
  });

  group('Bordas de faixas — A', () {
    test('1.32 ainda é Insignificante, 1.33 já é Pequena', () {
      expect(NivelAmeaca.fromValor(1.32), NivelAmeaca.insignificante);
      expect(NivelAmeaca.fromValor(1.33), NivelAmeaca.pequena);
    });
    test('Pontos canônicos das 5 faixas', () {
      expect(NivelAmeaca.fromValor(0.0), NivelAmeaca.insignificante);
      expect(NivelAmeaca.fromValor(1.167), NivelAmeaca.insignificante);
      expect(NivelAmeaca.fromValor(2.0), NivelAmeaca.pequena);
      expect(NivelAmeaca.fromValor(4.0), NivelAmeaca.moderada);
      expect(NivelAmeaca.fromValor(7.0), NivelAmeaca.significante);
      expect(NivelAmeaca.fromValor(9.17), NivelAmeaca.extrema);
    });
  });
}
