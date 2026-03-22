import 'package:get/get.dart';

import '../controllers/schedules_page_controller.dart';

class SchedulesPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchedulesPageController>(
      () => SchedulesPageController(),
    );
  }
}
