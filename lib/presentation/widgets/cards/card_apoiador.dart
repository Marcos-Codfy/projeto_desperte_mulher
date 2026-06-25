// Card de apoiador / parceiro — usado nas páginas Apoios e Falar.
//
// Por enquanto, sem PNG de logo, mostra um placeholder com a inicial.
// Quando o Davi mandar os logos reais, basta passar `caminhoLogo`.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class CardApoiador extends StatelessWidget {
  final String nome;
  final String? descricao;
  final String? caminhoLogo;
  final String? telefoneAcao;
  final String? urlAcao;
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
    return Material(
      color: AppCores.fundoCard,
      borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
      child: InkWell(
        onTap: aoTocar,
        borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
        child: Container(
          padding: const EdgeInsets.all(AppDimensoes.e16),
          decoration: BoxDecoration(
            border: Border.all(color: AppCores.divisor),
            borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Logo(nome: nome, caminho: caminhoLogo),
              const SizedBox(height: AppDimensoes.e12),
              Text(nome, style: AppTipografia.tituloH3),
              if (descricao != null) ...[
                const SizedBox(height: AppDimensoes.e8),
                Text(descricao!, style: AppTipografia.corpoPequeno),
              ],
              if (telefoneAcao != null) ...[
                const SizedBox(height: AppDimensoes.e12),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: AppCores.primaria),
                    const SizedBox(width: AppDimensoes.e8),
                    Text(
                      telefoneAcao!,
                      style: AppTipografia.corpo.copyWith(
                        color: AppCores.primaria,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String nome;
  final String? caminho;

  const _Logo({required this.nome, this.caminho});

  @override
  Widget build(BuildContext context) {
    if (caminho != null) {
      return SizedBox(
        height: 56,
        child: Image.asset(
          caminho!,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
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
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: AppCores.primariaFundo,
        borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
      ),
      alignment: Alignment.center,
      child: Text(
        iniciais,
        style: AppTipografia.tituloH3.copyWith(color: AppCores.primariaEscura),
      ),
    );
  }
}
