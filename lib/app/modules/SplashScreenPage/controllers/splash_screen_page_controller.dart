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

  checkUserIsLoggedIn() async {
    await Future.wait([
      _fetchServerTime(),
      Future.delayed(const Duration(milliseconds: 1500)),
    ]);
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
