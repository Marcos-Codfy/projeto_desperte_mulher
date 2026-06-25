// AvaliacaoPage — o coração do app.
//
// Stepper de 5 etapas com perguntas, MedidorRisco + bottom bar fixos
// no rodapé, navegação Voltar / Próximo / Ver Resultado.
//
// O estado vive em AvaliacaoController; aqui só dispara setState.
//
// DECISÕES DE UX MOBILE-FIRST (branch ux/mobile-first-polish):
//   • Botões Voltar/Próximo são FIXOS no rodapé (BarraNavegacaoEtapa),
//     não rolam com o conteúdo. Polegar acessa sem fricção.
//   • Footer da app é escondido nesta tela — o rodapé fixo já ocupa
//     atenção, e o footer institucional polui o foco.
//   • Ao trocar de etapa, mostramos um overlay de microcopia
//     acolhedora por ~2s antes de revelar a próxima etapa, com
//     scroll já no topo. Pausa cognitiva entre blocos pesados.
//   • A AvaliacaoPage controla o scroll do scaffold diretamente
//     (passa scrollController), eliminando o bug de "etapa nova
//     abrir na mesma posição de scroll da anterior".

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/data/repositories/quiz_repository_impl.dart';
import 'package:desperte_mulher/presentation/pages/avaliacao/controller/avaliacao_controller.dart';
import 'package:desperte_mulher/presentation/widgets/botoes/botao_primario.dart';
import 'package:desperte_mulher/presentation/widgets/cards/card_pergunta.dart';
import 'package:desperte_mulher/presentation/widgets/feedback/barra_navegacao_etapa.dart';
import 'package:desperte_mulher/presentation/widgets/feedback/medidor_risco.dart';
import 'package:desperte_mulher/presentation/widgets/feedback/overlay_microcopia_etapa.dart';
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

  /// Microcopia a exibir no overlay entre etapas — null = sem overlay.
  String? _microcopiaEntreEtapas;

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

  /// Rola o conteúdo de volta pro topo.
  /// Usa postFrameCallback para garantir que o ListView/Column já
  /// foi rebuilt com a etapa nova antes de a gente mexer no offset.
  void _scrollarParaOTopo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(0);
    });
  }

  void _voltarEtapa() {
    setState(_controller.voltarParaEtapaAnterior);
    _scrollarParaOTopo();
  }

  void _avancarOuFinalizar() {
    final ok = _controller.validarEtapa();
    if (!ok) {
      setState(() {}); // rebuild para mostrar cards com erro
      _scrollarParaOTopo();
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
    final etapaAntes = _controller.etapaAtual;
    setState(() {
      _controller.irParaProximaEtapa();
      _microcopiaEntreEtapas = _selecionarMicrocopia(
        deEtapa: etapaAntes,
        paraEtapa: _controller.etapaAtual,
      );
    });
    _scrollarParaOTopo();
  }

  /// Devolve a frase certa para a transição (etapa N → N+1).
  /// Null = não mostrar overlay.
  String? _selecionarMicrocopia({required int deEtapa, required int paraEtapa}) {
    if (paraEtapa <= deEtapa) return null;
    switch (deEtapa) {
      case 1:
        return AppStrings.microcopiaEntreEtapas1para2;
      case 2:
        return AppStrings.microcopiaEntreEtapas2para3;
      case 3:
        return AppStrings.microcopiaEntreEtapas3para4;
      case 4:
        return AppStrings.microcopiaEntreEtapas4para5;
      default:
        return null;
    }
  }

  void _fecharOverlay() {
    if (!mounted) return;
    setState(() => _microcopiaEntreEtapas = null);
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
        mostrarFooter: false,
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

    final corpo = ScaffoldAcolhedor(
      scrollController: _scrollController,
      mostrarFooter: false,
      rodapeFixo: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MedidorRisco(
            percentualPreenchido: _controller.percentualGlobal,
            grauProjetado: _controller.grauProjetado,
          ),
          BarraNavegacaoEtapa(
            mostrarVoltar: !_controller.ehPrimeiraEtapa,
            ehUltimaEtapa: _controller.ehUltimaEtapa,
            aoVoltar: _voltarEtapa,
            aoAvancar: _avancarOuFinalizar,
          ),
        ],
      ),
      conteudo: Column(
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
          Paragrafo(
            AppStrings.avaliacaoEntreEtapasSutil,
            textAlign: TextAlign.center,
          ),
          // Espaço final para o conteúdo "respirar" acima da bottom bar.
          const SizedBox(height: AppDimensoes.e32),
        ],
      ),
    );

    // Overlay de microcopia (entre etapas) renderiza acima de tudo —
    // só some quando o timer ou o toque dispensam.
    final overlay = _microcopiaEntreEtapas;
    if (overlay == null) return corpo;
    return Stack(
      children: [
        corpo,
        Positioned.fill(
          child: OverlayMicrocopiaEtapa(
            texto: overlay,
            aoFechar: _fecharOverlay,
          ),
        ),
      ],
    );
  }
}
