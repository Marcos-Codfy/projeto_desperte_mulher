// Footer padrão da aplicação: telefones de emergência + créditos.
//
// Aparece em TODA página, por design — a usuária pode estar em qualquer
// fluxo e precisar de um número de emergência imediatamente.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';

class FooterApp extends StatelessWidget {
  const FooterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppCores.fundoSecundario,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensoes.e24,
        vertical: AppDimensoes.e32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensoes.larguraMaximaConteudo,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.footerEmergenciaTitulo,
                style: AppTipografia.tituloH3,
              ),
              const SizedBox(height: AppDimensoes.e12),
              Wrap(
                spacing: AppDimensoes.e24,
                runSpacing: AppDimensoes.e12,
                children: const [
                  _ItemEmergencia(numero: '180', texto: AppStrings.footer180),
                  _ItemEmergencia(numero: '190', texto: AppStrings.footer190),
                ],
              ),
              const SizedBox(height: AppDimensoes.e24),
              const Divider(color: AppCores.divisor),
              const SizedBox(height: AppDimensoes.e12),
              Text(
                AppStrings.footerCreditos,
                style: AppTipografia.corpoPequeno,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemEmergencia extends StatelessWidget {
  final String numero;
  final String texto;
  const _ItemEmergencia({required this.numero, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensoes.e12,
            vertical: AppDimensoes.e8,
          ),
          decoration: BoxDecoration(
            color: AppCores.primaria,
            borderRadius: BorderRadius.circular(AppDimensoes.raioPequeno),
          ),
          child: Text(
            numero,
            style: AppTipografia.tituloH3.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: AppDimensoes.e12),
        Flexible(
          child: Text(texto, style: AppTipografia.corpo),
        ),
      ],
    );
  }
}
