// CardPergunta — o widget reutilizado nas 30 perguntas do FONAR.
//
// Suporta os 2 modos (única/múltipla). Mantém o estado da seleção via
// callback (estado externo, gerenciado pelo AvaliacaoController).
//
// 4 estados visuais:
//   - Não respondida: borda divisor, fundo card
//   - Em foco:         borda primariaClara, fundo card
//   - Respondida:      borda terciaria + ícone de check discreto
//   - Com erro:        borda erro + fundo erroFundo + microcopy acolhedor
//                      "Quando estiver pronta, escolha uma opção…"
//
// Acessibilidade:
//   - Cada opção é tocável em área ≥48px
//   - Anuncia estado de seleção via Semantics
//   - Microcopy de erro tem liveRegion: true para anúncio automático

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/domain/entities/pergunta.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class CardPergunta extends StatelessWidget {
  /// A pergunta a renderizar.
  final Pergunta pergunta;

  /// Índices das opções marcadas (estado externo).
  final List<int> opcoesMarcadas;

  /// Disparado quando a usuária muda a seleção.
  /// Recebe a nova lista de índices marcados.
  final void Function(List<int> novosIndices) aoMudar;

  /// Se deve mostrar a borda/microcopy de erro
  /// (chamado depois que ela clica Próximo sem responder).
  final bool mostrarErro;

  const CardPergunta({
    super.key,
    required this.pergunta,
    required this.opcoesMarcadas,
    required this.aoMudar,
    this.mostrarErro = false,
  });

  bool get _respondida => opcoesMarcadas.isNotEmpty;

  Color get _corBorda {
    if (mostrarErro) return AppCores.erro;
    if (_respondida) return AppCores.terciaria;
    return AppCores.divisor;
  }

  Color get _corFundo {
    if (mostrarErro) return AppCores.erroFundo;
    return AppCores.fundoCard;
  }

  void _toggle(int idx) {
    final lista = List<int>.from(opcoesMarcadas);
    if (pergunta.modo == ModoSelecao.unica) {
      aoMudar([idx]);
      return;
    }
    if (lista.contains(idx)) {
      lista.remove(idx);
    } else {
      lista.add(idx);
    }
    aoMudar(lista);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _corFundo,
        border: Border.all(color: _corBorda, width: _respondida || mostrarErro ? 2 : 1),
        borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
      ),
      padding: const EdgeInsets.all(AppDimensoes.e16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NumeroPergunta(numero: pergunta.numero),
              const SizedBox(width: AppDimensoes.e12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        pergunta.texto,
                        style: AppTipografia.tituloH3,
                      ),
                    ),
                    if (pergunta.textoApoio != null) ...[
                      const SizedBox(height: AppDimensoes.e8),
                      TextoApoio(pergunta.textoApoio!),
                    ],
                  ],
                ),
              ),
              if (_respondida && !mostrarErro)
                const Icon(Icons.check_circle, color: AppCores.terciaria, size: 20),
            ],
          ),
          const SizedBox(height: AppDimensoes.e16),
          ...List.generate(pergunta.opcoes.length, (i) {
            final opcao = pergunta.opcoes[i];
            final marcada = opcoesMarcadas.contains(i);
            return _ItemOpcao(
              texto: opcao.texto,
              marcada: marcada,
              modo: pergunta.modo,
              aoToque: () => _toggle(i),
            );
          }),
          if (mostrarErro) ...[
            const SizedBox(height: AppDimensoes.e12),
            Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18, color: AppCores.erro),
                  const SizedBox(width: AppDimensoes.e8),
                  Expanded(
                    child: Text(
                      AppStrings.avaliacaoErroFaltam,
                      style: AppTipografia.corpoPequeno.copyWith(color: AppCores.erro),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NumeroPergunta extends StatelessWidget {
  final String numero;
  const _NumeroPergunta({required this.numero});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e8,
        vertical: AppDimensoes.e4,
      ),
      decoration: BoxDecoration(
        color: AppCores.primariaFundo,
        borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
      ),
      child: Text(
        numero,
        style: AppTipografia.corpoPequeno.copyWith(
          color: AppCores.primariaEscura,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ItemOpcao extends StatelessWidget {
  final String texto;
  final bool marcada;
  final ModoSelecao modo;
  final VoidCallback aoToque;

  const _ItemOpcao({
    required this.texto,
    required this.marcada,
    required this.modo,
    required this.aoToque,
  });

  @override
  Widget build(BuildContext context) {
    final corBorda = marcada ? AppCores.primaria : AppCores.divisor;
    final corFundo = marcada ? AppCores.primariaFundo : AppCores.fundoCard;

    return Semantics(
      checked: marcada,
      inMutuallyExclusiveGroup: modo == ModoSelecao.unica,
      button: true,
      label: texto,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimensoes.e8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: aoToque,
            borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
            child: Container(
              constraints: const BoxConstraints(minHeight: AppDimensoes.tamanhoMinimoToque),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensoes.e12,
                vertical: AppDimensoes.e8,
              ),
              decoration: BoxDecoration(
                color: corFundo,
                border: Border.all(color: corBorda, width: marcada ? 2 : 1),
                borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
              ),
              child: Row(
                children: [
                  _IndicadorVisual(marcada: marcada, modo: modo),
                  const SizedBox(width: AppDimensoes.e12),
                  Expanded(
                    child: Text(
                      texto,
                      style: AppTipografia.corpo.copyWith(
                        color: marcada
                            ? AppCores.primariaEscura
                            : AppCores.textoPrincipal,
                        fontWeight: marcada ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicadorVisual extends StatelessWidget {
  final bool marcada;
  final ModoSelecao modo;

  const _IndicadorVisual({required this.marcada, required this.modo});

  @override
  Widget build(BuildContext context) {
    final corBorda = marcada ? AppCores.primaria : AppCores.textoApagado;

    if (modo == ModoSelecao.unica) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: corBorda, width: 2),
        ),
        child: marcada
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppCores.primaria,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      );
    }
    // múltipla
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: marcada ? AppCores.primaria : Colors.transparent,
        border: Border.all(color: corBorda, width: 2),
        borderRadius: BorderRadius.circular(AppDimensoes.e4),
      ),
      child: marcada
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
