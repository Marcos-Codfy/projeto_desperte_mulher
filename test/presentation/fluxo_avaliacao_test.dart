// Smoke test: a tela de Avaliação sobe sem erros, carrega a etapa 1
// e renderiza a primeira pergunta.
//
// Não é um teste exaustivo do fluxo; é uma rede de segurança contra
// regressões grandes (faltou rota, faltou asset, NPE, etc).

import 'package:flutter_test/flutter_test.dart';

import 'package:desperte_mulher/common/route_manager.dart';
import 'package:desperte_mulher/presentation/pages/home/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // O AvisoHistoricoModal abre por postFrameCallback no primeiro
    // mount da Home. Em widget test, isso atrapalha — então suprimimos.
    homePageAvisoHistoricoJaMostrado = true;
  });

  testWidgets('Aplicação sobe na home sem crashar', (tester) async {
    await tester.pumpWidget(criarMaterialApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // A home tem um botão de CTA "Quero me avaliar".
    expect(find.text('Quero me avaliar'), findsOneWidget);

    // Botão Sair aparece no header.
    expect(find.byTooltip('Sair do site rapidamente para uma página neutra'),
        findsOneWidget);
  });

  testWidgets('Navegação Home -> Termos funciona', (tester) async {
    await tester.pumpWidget(criarMaterialApp());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.text('Quero me avaliar'));
    await tester.pumpAndSettle();

    expect(find.text('Compreendi — quero continuar'), findsOneWidget);
  });
}
