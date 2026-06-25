// Factory que monta o MaterialApp da aplicação.
// Estilo Silvano Malfatti: rotas centralizadas, MaterialApp construído
// fora do main.dart, tema único.
//
// Rotas conhecidas estão em [AppRotas]. Qualquer rota desconhecida cai
// no NaoEncontradaPage (404 acolhedor).

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_routes.dart';
import 'package:desperte_mulher/common/app_strings.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/pages/analise/analise_page.dart';
import 'package:desperte_mulher/presentation/pages/apoios/apoios_page.dart';
import 'package:desperte_mulher/presentation/pages/avaliacao/avaliacao_page.dart';
import 'package:desperte_mulher/presentation/pages/falar/falar_page.dart';
import 'package:desperte_mulher/presentation/pages/home/home_page.dart';
import 'package:desperte_mulher/presentation/pages/nao_encontrada/nao_encontrada_page.dart';
import 'package:desperte_mulher/presentation/pages/resultado/resultado_page.dart';
import 'package:desperte_mulher/presentation/pages/sobre/sobre_page.dart';
import 'package:desperte_mulher/presentation/pages/termos/termos_page.dart';

MaterialApp criarMaterialApp() {
  return MaterialApp(
    title: AppStrings.tituloApp,
    debugShowCheckedModeBanner: false,
    theme: construirTema(),
    initialRoute: AppRotas.home,
    routes: <String, WidgetBuilder>{
      AppRotas.home: (_) => const HomePage(),
      AppRotas.sobre: (_) => const SobrePage(),
      AppRotas.analise: (_) => const AnalisePage(),
      AppRotas.apoios: (_) => const ApoiosPage(),
      AppRotas.termos: (_) => const TermosPage(),
      AppRotas.falar: (_) => const FalarPage(),
      AppRotas.avaliacao: (_) => const AvaliacaoPage(),
      AppRotas.resultado: (_) => const ResultadoPage(),
    },
    onUnknownRoute: (_) => MaterialPageRoute<void>(
      builder: (_) => const NaoEncontradaPage(),
    ),
  );
}
