// AvaliacaoPage — o coração do app.
//
// Stepper de 5 etapas com perguntas, MedidorRisco sticky no rodapé,
// navegação Voltar / Próximo / Ver Resultado.
//
// O estado vive em AvaliacaoController; aqui só dispara setState.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/data/repositories/quiz_repository_impl.dart';
import 'package:desperte_mulher/presentation/pages/avaliacao/controller/avaliacao_controller.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_secundario.dart';
import 'package:desperte_mulher/presentation/widgets/cards/card_pergunta.dart';
import 'package:desperte_mulher/presentation/widgets/feedback/medidor_risco.dart';
import 'package:desperte_mulher/presentation/widgets/feedback/progresso_etapas.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class AvaliacaoPage extends StatefulWidget {
  const AvaliacaoPage({super.key});

  @override
  State<AvaliacaoPage> createState() => _AvaliacaoPageState();
}

class _AvaliacaoPageState extends State<AvaliacaoPage> {
  late final AvaliacaoController _controller;
  bool _carregando = true;
  String? _erroCarregamento;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AvaliacaoController(
      repositorio: const QuizRepositoryImpl(),
    );
    _inicializar();
  }

  Future<void> _inicializar() async {
    try {
      await _controller.inicializar();
    } catch (e) {
      if (!mounted) return;
      setState(() => _erroCarregamento = e.toString());
      return;
    }
    if (!mounted) return;
    setState(() => _carregando = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _aoMudarResposta(String idPergunta, List<int> indices) {
    setState(() => _controller.registrarResposta(idPergunta, indices));
  }

  void _voltarEtapa() {
    setState(() {
      _controller.voltarParaEtapaAnterior();
      _scrollController.jumpTo(0);
    });
  }

  void _avancarOuFinalizar() {
    final ok = _controller.validarEtapa();
    if (!ok) {
      setState(() {}); // rebuild para mostrar cards com erro
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }
    if (_controller.ehUltimaEtapa) {
      final resultado = _controller.calcularResultadoFinal();
      Navigator.of(context).pushReplacementNamed(
        AppRotas.resultado,
        arguments: resultado,
      );
      return;
    }
    setState(() {
      _controller.irParaProximaEtapa();
      _scrollController.jumpTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_erroCarregamento != null) {
      return ScaffoldAcolhedor(
        conteudo: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TituloH1('Tivemos um problema ao carregar as perguntas'),
            const SizedBox(height: AppDimensoes.e16),
            Paragrafo(_erroCarregamento!),
            const SizedBox(height: AppDimensoes.e24),
            BotaoPrimario(
              texto: 'Tentar de novo',
              aoPressionar: () {
                setState(() {
                  _erroCarregamento = null;
                  _carregando = true;
                });
                _inicializar();
              },
            ),
          ],
        ),
      );
    }
    if (_carregando) {
      return const ScaffoldAcolhedor(
        conteudo: Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensoes.e64),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(color: AppCores.primaria),
                SizedBox(height: AppDimensoes.e16),
                Paragrafo(AppStrings.avaliacaoCarregando),
              ],
            ),
          ),
        ),
      );
    }

    final etapa = _controller.etapaCorrente;

    return ScaffoldAcolhedor(
      rodapeFixo: MedidorRisco(
        percentualPreenchido: _controller.percentualGlobal,
        grauProjetado: _controller.grauProjetado,
      ),
      conteudo: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressoEtapas(
              etapaAtual: _controller.etapaAtual,
              totalEtapas: _controller.totalEtapas,
            ),
            const SizedBox(height: AppDimensoes.e24),
            TituloH1(etapa.titulo),
            const SizedBox(height: AppDimensoes.e8),
            Paragrafo(etapa.subtitulo, grande: true),
            const SizedBox(height: AppDimensoes.e24),
            ...etapa.perguntas.expand(
              (p) => [
                CardPergunta(
                  pergunta: p,
                  opcoesMarcadas: _controller.respostaDe(p.id),
                  aoMudar: (idx) => _aoMudarResposta(p.id, idx),
                  mostrarErro: _controller.temErro(p.id),
                ),
                const SizedBox(height: AppDimensoes.e16),
              ],
            ),
            const SizedBox(height: AppDimensoes.e8),
            const Paragrafo(
              AppStrings.avaliacaoEntreEtapas,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensoes.e24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!_controller.ehPrimeiraEtapa)
                  BotaoSecundario(
                    texto: AppStrings.avaliacaoVoltar,
                    icone: Icons.arrow_back,
                    aoPressionar: _voltarEtapa,
                  )
                else
                  const SizedBox.shrink(),
                BotaoPrimario(
                  texto: _controller.ehUltimaEtapa
                      ? AppStrings.avaliacaoVerResultado
                      : AppStrings.avaliacaoProximo,
                  icone: _controller.ehUltimaEtapa
                      ? Icons.check
                      : Icons.arrow_forward,
                  tamanho: TamanhoBotao.grande,
                  aoPressionar: _avancarOuFinalizar,
                ),
              ],
            ),
            const SizedBox(height: AppDimensoes.e64),
          ],
        ),
      ),
    );
  }
}
