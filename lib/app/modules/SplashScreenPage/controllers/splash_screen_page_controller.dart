import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/app_images.dart';
import 'package:get/get.dart';

class SplashScreenPageController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    checkUserIsLoggedIn();
  }

  String get appImageLogo => AppImages.appLogo;

  /// Hard cap on how long the splash may wait for the server-time fetch.
  /// ServerTime already defaults to UTC+3, so the fetch is an optimisation —
  /// leaving the splash is never allowed to depend on the network succeeding.
  static const Duration _serverTimeBudget = Duration(seconds: 3);

  checkUserIsLoggedIn() async {
    try {
      await Future.wait([
        _fetchServerTime().timeout(_serverTimeBudget, onTimeout: () {}),
        Future.delayed(const Duration(milliseconds: 1500)),
      ]);
    } catch (_) {
      // Never block the handoff to the login page on startup work.
    }
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }

  Future<void> _fetchServerTime() async {
    try {
      final resp = await ApiController.to
          .callGETAPI(url: APIUrlsService.to.serverTime);
      if (resp is Map<String, dynamic> && resp['timezone_offset'] != null) {
        ServerTime.setOffset((resp['timezone_offset'] as num).toInt());
      }
    } catch (_) {
      // keep default UTC+3 fallback
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
