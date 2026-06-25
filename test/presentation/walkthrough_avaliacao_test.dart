// "Caminhada da usuária" — sobe a app de verdade, navega da Home até
// a primeira etapa da Avaliação, responde a 1ª pergunta, e verifica
// que o medidor renderiza.
//
// Este teste foi escrito DEPOIS de um bug em produção (Container com
// color+decoration ao mesmo tempo no MedidorRisco) ter passado por
// flutter analyze sem ser detectado. A assertion só dispara quando
// o widget é construído de verdade — daí a importância deste teste.

import 'dart:ui' show Size;

import 'package:flutter_test/flutter_test.dart';

import 'package:desperte_mulher/common/route_manager.dart';
import 'package:desperte_mulher/presentation/pages/home/home_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    homePageAvisoHistoricoJaMostrado = true;
  });

  testWidgets(
    'Fluxo completo: Home -> Termos -> Avaliação etapa 1 (com medidor)',
    (tester) async {
      // Viewport grande para evitar falsos overflows; o objetivo deste
      // teste é capturar crashes de construção, não polish responsivo.
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(criarMaterialApp());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // ── Home → clique no CTA ───────────────────────────────────────
      expect(find.text('Quero me avaliar'), findsOneWidget);
      await tester.tap(find.text('Quero me avaliar'));
      await tester.pumpAndSettle();

      // ── Termos → clique em "Compreendi" ────────────────────────────
      final btnCompreendi = find.text('Compreendi — quero continuar');
      expect(btnCompreendi, findsOneWidget);
      // O botão pode estar abaixo do viewport — rola até ele primeiro.
      await tester.ensureVisible(btnCompreendi);
      await tester.pumpAndSettle();
      await tester.tap(btnCompreendi);
      await tester.pumpAndSettle();

      // ── Avaliação carrega: aguarda o delay simulado do datasource ──
      // O QuizLocalDataSource tem Future.delayed(600ms). Em widget test,
      // Future.delayed só "passa" dentro de runAsync (pump não avança
      // real time, só pump frames). Após o delay, voltamos a pumpar
      // pra que setState do FutureBuilder/initState propague.
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 800));
      });
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // ── A primeira pergunta deve estar visível ─────────────────────
      expect(
        find.textContaining('O(A) agressor(a) já ameaçou'),
        findsOneWidget,
        reason: 'Pergunta 1 deve aparecer na Etapa 1',
      );

      // ── O medidor de risco deve estar montado (sem crashar) ────────
      // Esta é a verificação anti-regressão do bug "Container com color
      // e decoration juntos" — se o widget falhar em construir, esta
      // expectativa não acha nada.
      expect(
        find.text('Você está construindo seu mapa de segurança.'),
        findsOneWidget,
        reason: 'O MedidorRisco deve renderizar sem assertion failure',
      );

      // ── Botão Próximo presente ─────────────────────────────────────
      expect(find.text('Próximo'), findsOneWidget);
    },
    timeout: const Timeout(Duration(seconds: 30)),
  );
}
