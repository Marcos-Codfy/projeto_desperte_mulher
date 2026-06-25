// Overlay de microcopia mostrado entre uma etapa e outra da Avaliação.
//
// O QUE FAZ: cobre a tela com um fundo semitransparente acolhedor e
// mostra uma frase grande, centralizada, por ~2 segundos. Some sozinho
// (timer) ou se a usuária tocar em qualquer lugar (dismiss antecipado).
//
// POR QUÊ: depois de responder um bloco pesado (ex.: histórico de
// violência), a vítima precisa de uma pausa cognitiva antes de
// continuar. Sem essa pausa, o "questionnaire fatigue" cresce e o
// abandono no meio aumenta — sobretudo em populações em crise.
//
// PRINCÍPIO: a microcopia NUNCA é imperativa. Nunca diz "respira" ou
// "continue" como ordem — sempre devolve o controle pra ela. Frases
// definidas em AppStrings.microcopiaEntreEtapasNparaM.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class OverlayMicrocopiaEtapa extends StatefulWidget {
  /// Texto exato que será mostrado. Já vem da AppStrings.
  final String texto;

  /// Quanto tempo o overlay fica antes de sumir sozinho.
  final Duration duracao;

  /// Disparado quando o overlay some — por timer ou por toque.
  /// A AvaliacaoPage usa esse callback para limpar a flag de estado.
  final VoidCallback aoFechar;

  const OverlayMicrocopiaEtapa({
    super.key,
    required this.texto,
    required this.aoFechar,
    // 6 segundos = tempo de ler a frase (~3.5s) + uma respiração
    // consciente (~2-3s). Literatura de "trauma-informed UI" sugere
    // a faixa 4–8s para populações em crise — abaixo de 4s o texto
    // ainda está sendo lido quando o overlay some; acima de 8s vira
    // interrupção. Toque para dispensar antes está sempre disponível.
    this.duracao = const Duration(seconds: 6),
  });

  @override
  State<OverlayMicrocopiaEtapa> createState() => _OverlayMicrocopiaEtapaState();
}

class _OverlayMicrocopiaEtapaState extends State<OverlayMicrocopiaEtapa>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacity;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _opacity = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _animController.forward();
    _timer = Timer(widget.duracao, _fechar);
  }

  void _fechar() {
    if (!mounted) return;
    _timer?.cancel();
    _animController.reverse().whenComplete(() {
      if (!mounted) return;
      widget.aoFechar();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: widget.texto,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _fechar,
        child: FadeTransition(
          opacity: _opacity,
          // Material transparente como ancestor do Text é o que evita
          // o sublinhado amarelo de debug do Flutter ("missing Material
          // ancestor"). O Container colorido abaixo continua dando a
          // cor do veil; o Material só fornece o contexto necessário
          // para o Text não cair no fallback decorativo.
          child: Material(
            color: Colors.transparent,
            child: Container(
              // Veil acolhedor: o fundo da app com leve transparência;
              // NÃO usamos preto / branco — manter a paleta da plataforma.
              color: AppCores.fundo.withValues(alpha: 0.96),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensoes.e32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  widget.texto,
                  textAlign: TextAlign.center,
                  style: AppTipografia.tituloH2.copyWith(
                    color: AppCores.primariaEscura,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
