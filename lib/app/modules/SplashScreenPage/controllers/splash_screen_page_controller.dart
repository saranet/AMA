import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/utils/app_images.dart';
import 'package:get/get.dart';
import '../../../../data/controllers/app_storage_service.dart';

class SplashScreenPageController extends GetxController {
  //TODO: Implement SplashScreenPageController

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
    if (await AppStorageController.to.isUserLoggedIn()) {
      Get.offAllNamed(Routes.DASH_BOARD_PAGE);
    } else {
      Get.offAndToNamed(Routes.LOGIN_PAGE);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
