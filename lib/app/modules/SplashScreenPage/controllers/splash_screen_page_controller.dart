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
    await Future.delayed(const Duration(milliseconds: 1500));
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
