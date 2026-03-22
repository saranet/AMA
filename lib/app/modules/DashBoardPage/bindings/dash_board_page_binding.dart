import 'package:get/get.dart';

import '../controllers/dash_board_page_controller.dart';

class DashBoardPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardPageController>(
      () => DashboardPageController(),
    );
  }
}
