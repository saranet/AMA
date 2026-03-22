import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/widgets/SessionManager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'data/intial_binding.dart'; // Add this import if InitialBinding is defined here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    SessionManager(
      timeoutMinutes: 5, // مدة عدم النشاط
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: AppPages.routes,
        initialRoute: AppPages.INITIAL,
        theme: appTheme,
        initialBinding: InitialBinding(),
      ),
    ),
  );
}
