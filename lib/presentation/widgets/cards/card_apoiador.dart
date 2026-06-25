// Card de apoiador / parceiro — usado nas páginas Apoios e Falar.
//
// Refinado para a tela "Falar com a rede": logo num selo lavanda no
// topo (equaliza proporções diferentes entre logos), nome e descrição
// no meio, CTA claro no rodapé. Para cards sem telefone (informativos),
// o rodapé degrada para um label sutil "Saiba mais →".

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class CardApoiador extends StatelessWidget {
  final String nome;
  final String? descricao;
  final String? caminhoLogo;

  /// Número exibido no CTA. Se null, o card é informativo (sem botão).
  final String? telefoneAcao;

  /// URL informativa (não muda o visual hoje; reservado para a v2).
  final String? urlAcao;

  /// Chamado ao tocar em qualquer ponto do card. Em geral, a página
  /// que monta o card associa este callback ao `ligarPara(telefone)`.
  final VoidCallback? aoTocar;

  const CardApoiador({
    super.key,
    required this.nome,
    this.descricao,
    this.caminhoLogo,
    this.telefoneAcao,
    this.urlAcao,
    this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    final temCTA = telefoneAcao != null;
    return Material(
      color: AppCores.fundoCard,
      borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: aoTocar,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppCores.divisor),
            borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Selo da logo (topo) ──
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensoes.e24,
                  horizontal: AppDimensoes.e16,
                ),
                decoration: const BoxDecoration(
                  color: AppCores.primariaFundo,
                ),
                child: _Logo(nome: nome, caminho: caminhoLogo),
              ),

              // ── Corpo (nome + descrição) ──
              Padding(
                padding: const EdgeInsets.all(AppDimensoes.e16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nome,
                      style: AppTipografia.tituloH3.copyWith(height: 1.3),
                    ),
                    if (descricao != null) ...[
                      const SizedBox(height: AppDimensoes.e8),
                      Text(
                        descricao!,
                        style: AppTipografia.corpoPequeno.copyWith(
                          color: AppCores.textoSecundario,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Rodapé (CTA ou label sutil) ──
              if (temCTA)
                _RodapeCTA(numero: telefoneAcao!, aoTocar: aoTocar)
              else if (aoTocar != null)
                const _RodapeSaibaMais(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selo de logo no topo do card: equaliza visual entre logos
/// de proporções muito diferentes (vertical, quadrada, horizontal).
class _Logo extends StatelessWidget {
  final String nome;
  final String? caminho;

  const _Logo({required this.nome, this.caminho});

  @override
  Widget build(BuildContext context) {
    if (caminho != null) {
      return SizedBox(
        height: 80,
        child: Image.asset(
          caminho!,
          fit: BoxFit.contain,
          // Em caso de erro (asset ausente), cai pro placeholder.
          errorBuilder: (_, _, _) => _Placeholder(nome: nome),
        ),
      );
    }
    return _Placeholder(nome: nome);
  }
}

class _Placeholder extends StatelessWidget {
  final String nome;
  const _Placeholder({required this.nome});

  @override
  Widget build(BuildContext context) {
    final iniciais = nome
        .split(' ')
        .where((s) => s.isNotEmpty)
        .take(2)
        .map((s) => s[0].toUpperCase())
        .join();

    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: AppCores.primariaClara,
        borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
      ),
      alignment: Alignment.center,
      child: Text(
        iniciais,
        style: AppTipografia.tituloH2.copyWith(color: AppCores.primariaEscura),
      ),
    );
  }
}

/// Botão CTA "Ligar agora · 180" usado nos cards com telefone.
/// Não é um Botão (TextButton) separado para manter o card como
/// uma área inteira clicável — o InkWell do card dispara aoTocar.
class _RodapeCTA extends StatelessWidget {
  final String numero;
  final VoidCallback? aoTocar;
  const _RodapeCTA({required this.numero, this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e16,
        vertical: AppDimensoes.e12,
      ),
      decoration: const BoxDecoration(
        color: AppCores.primaria,
        border: Border(
          top: BorderSide(color: AppCores.divisor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone, size: 18, color: Colors.white),
          const SizedBox(width: AppDimensoes.e8),
          Text(
            'Ligar agora · $numero',
            style: AppTipografia.botao.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _RodapeSaibaMais extends StatelessWidget {
  const _RodapeSaibaMais();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e16,
        vertical: AppDimensoes.e12,
      ),
      decoration: const BoxDecoration(
        color: AppCores.fundoSecundario,
        border: Border(
          top: BorderSide(color: AppCores.divisor, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Saiba mais',
            style: AppTipografia.botao.copyWith(color: AppCores.primariaEscura),
          ),
          const SizedBox(width: AppDimensoes.e4),
          const Icon(Icons.arrow_forward, size: 16, color: AppCores.primariaEscura),
        ],
      ),
    );
  }
}
