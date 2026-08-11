import 'dart:async';
import 'dart:io';

import 'package:ama/app/modules/LoginPage/views/login_page_view.dart';
import 'package:ama/app/modules/SplashScreenPage/views/splash_screen_page_view.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/intial_binding.dart';
import 'package:ama/l10n/app_localizations.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// End-to-end cold-start smoke test — the closest analogue to what an App
/// Review tester does: install fresh, launch, and watch the first screen.
///
/// The reviewer's report was "App got stuck on a splash screen" on an iPad
/// with an active internet connection but (almost certainly) no route to our
/// API on port 8233. These tests reproduce that shape of failure and assert
/// the app still reaches the login screen.

/// Models the reviewer's network: connected, but our host never answers.
class _UnreachableApi extends ApiController {
  @override
  Future<dynamic> callGETAPI({required String url, int retryAttempt = 0}) =>
      Completer<dynamic>().future;

  @override
  Future<dynamic> callPOSTAPI({
    required String url,
    required dynamic body,
    int retryAttempt = 0,
  }) =>
      Completer<dynamic>().future;
}

/// Mirrors main.dart. Kept in sync deliberately: testing a different widget
/// tree than the one we ship would prove nothing.
Widget buildApp(String lang) => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      theme: appTheme,
      initialBinding: InitialBinding(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: Locale(lang),
      fallbackLocale: const Locale('ar'),
    );

/// The splash animates forever, so pumpAndSettle would never return. Step
/// time forward manually instead.
Future<void> advance(WidgetTester tester, Duration total) async {
  const step = Duration(milliseconds: 250);
  for (var elapsed = Duration.zero; elapsed < total; elapsed += step) {
    await tester.pump(step);
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // GetStorage reaches for the app documents directory, which has no plugin
    // implementation under `flutter test`. Point it at a scratch directory.
    final scratch = Directory.systemTemp.createTempSync('ama_smoke_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => scratch.path,
    );
    addTearDown(() {
      // Best effort: GetStorage keeps its file handle open, and Windows will
      // not delete a file that is still held.
      try {
        scratch.deleteSync(recursive: true);
      } on FileSystemException {
        // Scratch directory; the OS reclaims it.
      }
    });

    await GetStorage.init();
  });

  setUp(() {
    Get.reset();
    Get.testMode = true;
    ApiController.to = _UnreachableApi();
  });

  for (final lang in ['ar', 'en']) {
    testWidgets('cold start reaches login in $lang with the API unreachable',
        (tester) async {
      await tester.pumpWidget(buildApp(lang));
      await tester.pump();

      expect(find.byType(SplashScreenPageView), findsOneWidget,
          reason: 'App should open on the splash screen.');

      // Well past the 3s server-time budget + 1.5s minimum splash display.
      await advance(tester, const Duration(seconds: 10));

      expect(
        find.byType(SplashScreenPageView),
        findsNothing,
        reason: 'STUCK ON SPLASH — this is the exact App Review 2.1(a) '
            'rejection. The splash must never wait on the network.',
      );
      expect(find.byType(LoginPageView), findsOneWidget,
          reason: 'App should hand off to the login screen.');
    });
  }

  testWidgets('login screen is interactive once reached', (tester) async {
    await tester.pumpWidget(buildApp('en'));
    await advance(tester, const Duration(seconds: 10));

    expect(find.byType(LoginPageView), findsOneWidget);

    // A reviewer must be able to type credentials. If the tree is covered by a
    // blocking overlay or spinner, these fields will not be hittable.
    final fields = find.byType(TextField);
    expect(fields, findsWidgets, reason: 'Login must expose input fields.');
    await tester.enterText(fields.first, 'reviewer');
    await tester.pump();
    expect(find.text('reviewer'), findsOneWidget);
  });
}
