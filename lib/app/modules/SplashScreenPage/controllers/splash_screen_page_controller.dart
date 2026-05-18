import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/utils/app_images.dart';
import 'package:get/get.dart';
import '../../../../data/controllers/app_storage_service.dart';

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
    // Run auth check and minimum animation time in parallel
    final results = await Future.wait([
      AppStorageController.to.isUserLoggedIn(),
      Future.delayed(const Duration(milliseconds: 1500)),
    ]);
    final isLoggedIn = results[0] as bool;
    if (isLoggedIn) {
      Get.offAllNamed(Routes.DASH_BOARD_PAGE);
    } else {
      Get.offAllNamed(Routes.LOGIN_PAGE);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
