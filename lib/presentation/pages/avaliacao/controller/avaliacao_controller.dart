// Controller da AvaliacaoPage — estado em RAM (sem persistência).
//
// Por escolha de design (sigilo da vítima), nada do que ela responde
// é salvo em localStorage, sessionStorage ou cookie. Se ela fecha o
// navegador, tudo é apagado.
//
// O AvaliacaoController centraliza:
//   - Quais perguntas existem (carregadas via QuizRepository)
//   - Qual é a etapa atual e o progresso global
//   - As respostas dadas até agora
//   - O cálculo de risco em tempo real (parcial) para o medidor

import 'package:flutter/foundation.dart';

import 'package:desperte_mulher/domain/entities/grau_risco.dart';
import 'package:desperte_mulher/domain/entities/pergunta.dart';
import 'package:desperte_mulher/domain/entities/resposta_usuaria.dart';
import 'package:desperte_mulher/domain/entities/resultado_arpax.dart';
import 'package:desperte_mulher/domain/repositories/quiz_repository.dart';
import 'package:desperte_mulher/domain/usecases/calcular_risco_arpax.dart';

/// Container de estado de uma avaliação em andamento.
/// Não estende ChangeNotifier — quem usa chama setState diretamente.
class AvaliacaoController {
  AvaliacaoController({
    required this.repositorio,
    this.motor = const CalcularRiscoArpax(),
  });

  final QuizRepository repositorio;
  final CalcularRiscoArpax motor;

  /// Etapas carregadas (5 ao todo). Vazio até `inicializar` rodar.
  final List<EtapaQuiz> _etapas = [];

  /// Respostas indexadas por id de pergunta.
  final Map<String, RespostaUsuaria> _respostas = {};

  /// 1-based. Sempre entre 1 e 5.
  int _etapaAtual = 1;

  /// Por id de pergunta, se devemos mostrar o erro "escolha uma opção".
  /// Limpo quando a usuária toca em qualquer opção daquela pergunta.
  final Set<String> _perguntasComErro = {};

  // ── Getters ──────────────────────────────────────────────────────────

  bool get carregado => _etapas.isNotEmpty;

  int get etapaAtual => _etapaAtual;
  int get totalEtapas => _etapas.isEmpty ? 5 : _etapas.first.totalEtapas;

  EtapaQuiz get etapaCorrente => _etapas[_etapaAtual - 1];

  bool get ehUltimaEtapa => _etapaAtual >= totalEtapas;
  bool get ehPrimeiraEtapa => _etapaAtual <= 1;

  /// Total de perguntas em todas as etapas (espelha as 30 do FONAR).
  int get totalPerguntas =>
      _etapas.fold<int>(0, (sum, e) => sum + e.perguntas.length);

  /// Quantas perguntas a usuária já respondeu (positiva ou negativamente).
  int get perguntasRespondidas => _respostas.values
      .where((r) => r.indicesMarcados.isNotEmpty)
      .length;

  /// 0.0..1.0 — pra alimentar o MedidorRisco.
  double get percentualGlobal {
    if (totalPerguntas == 0) return 0;
    return perguntasRespondidas / totalPerguntas;
  }

  /// Respostas de uma pergunta específica (lista de índices marcados).
  List<int> respostaDe(String idPergunta) {
    return _respostas[idPergunta]?.indicesMarcados ?? const [];
  }

  /// Se deve mostrar microcopy de erro nesta pergunta.
  bool temErro(String idPergunta) => _perguntasComErro.contains(idPergunta);

  /// Resultado parcial calculado a partir das respostas dadas até aqui.
  /// É usado pelo MedidorRisco pra estimar a cor da barra em tempo real.
  ResultadoArpax get resultadoParcial {
    final perguntasMap = <String, Pergunta>{};
    for (final etapa in _etapas) {
      for (final p in etapa.perguntas) {
        perguntasMap[p.id] = p;
      }
    }
    return motor.calcular(respostas: _respostas, perguntas: perguntasMap);
  }

  GrauRisco? get grauProjetado {
    if (perguntasRespondidas == 0) return null;
    return resultadoParcial.grauFinal;
  }

  // ── Ações ────────────────────────────────────────────────────────────

  /// Carrega as 5 etapas do repository.
  /// Deve ser chamado uma vez ao montar a AvaliacaoPage.
  Future<void> inicializar() async {
    if (_etapas.isNotEmpty) return;
    final etapas = await repositorio.carregarTodas();
    _etapas
      ..clear()
      ..addAll(etapas);
  }

  /// Registra resposta da usuária a uma pergunta.
  /// Limpa o erro daquela pergunta automaticamente.
  void registrarResposta(String idPergunta, List<int> indices) {
    _respostas[idPergunta] = RespostaUsuaria(
      idPergunta: idPergunta,
      indicesMarcados: List<int>.from(indices),
    );
    _perguntasComErro.remove(idPergunta);
  }

  /// Valida a etapa atual: marca erro nas perguntas sem resposta.
  /// Devolve true se está tudo respondido (ok para avançar).
  ///
  /// Perguntas que aceitam resposta vazia (16.b por ex., que tem
  /// criteriosAlimentados vazio e textoApoio dizendo "pule se preferir")
  /// são consideradas válidas mesmo sem marcação.
  bool validarEtapa() {
    _perguntasComErro.clear();
    var todasOk = true;
    for (final p in etapaCorrente.perguntas) {
      final resposta = _respostas[p.id];
      final temResposta =
          resposta != null && resposta.indicesMarcados.isNotEmpty;
      // P16b é opcional (criteriosAlimentados vazio + textoApoio "pule")
      final ehOpcional = p.criteriosAlimentados.isEmpty &&
          p.textoApoio != null &&
          p.textoApoio!.toLowerCase().contains('pule');
      if (!temResposta && !ehOpcional) {
        _perguntasComErro.add(p.id);
        todasOk = false;
      }
    }
    return todasOk;
  }

  /// Avança para a próxima etapa. Não valida — quem chama deve validar.
  void irParaProximaEtapa() {
    if (_etapaAtual < totalEtapas) _etapaAtual++;
  }

  /// Volta para a etapa anterior.
  void voltarParaEtapaAnterior() {
    if (_etapaAtual > 1) _etapaAtual--;
  }

  /// Calcula o resultado final (todas as etapas).
  ResultadoArpax calcularResultadoFinal() {
    return resultadoParcial;
  }

  /// Reseta tudo (botão "Refazer" da tela de Resultado).
  void resetar() {
    _respostas.clear();
    _perguntasComErro.clear();
    _etapaAtual = 1;
  }

  // Para debug — útil ao logar problemas em testes locais.
  @visibleForTesting
  Map<String, RespostaUsuaria> get respostasParaTeste => _respostas;
}
