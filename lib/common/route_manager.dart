// Factory que monta o MaterialApp da aplicação.
// Mantém main.dart trivial e isola toda a configuração de rotas/tema
// num lugar só. Estilo Silvano Malfatti.
//
// Nesta fase 0 ele é um placeholder mínimo para o app subir.
// Será reescrito na Fase 3 (Design System) e Fase 5 (rotas completas).

import 'package:flutter/material.dart';
import 'package:desperte_mulher/common/app_routes.dart';

MaterialApp criarMaterialApp() {
  return MaterialApp(
    title: 'Site',
    debugShowCheckedModeBanner: false,
    initialRoute: AppRotas.home,
    routes: <String, WidgetBuilder>{
      AppRotas.home: (_) => const _PlaceholderHome(),
    },
  );
}

/// Placeholder enquanto a HomePage definitiva não foi criada.
/// Será substituído na Fase 4.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Projeto Desperte Mulher\n\nEm construção — Fase 0 concluída.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
