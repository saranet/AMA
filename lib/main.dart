import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/l10n/app_localizations.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/widgets/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/intial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Load saved language from storage, default to Arabic
  final storage = GetStorage();
  final String savedLang = storage.read('lang') ?? 'ar';

  runApp(
    SessionManager(
      timeoutMinutes: 5,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: AppPages.routes,
        initialRoute: AppPages.INITIAL,
        theme: appTheme,
        initialBinding: InitialBinding(),

        // ── Localization setup ────────────────────────────────────────
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        locale: Locale(savedLang),
        fallbackLocale: const Locale('ar'),

        // RTL direction is handled AUTOMATICALLY by Flutter based on locale.
        // When locale is 'ar', the whole app flips to right-to-left.
        // When locale is 'en', it stays left-to-right.
      ),
    ),
  );
}
