import 'package:get/get.dart';

import '../controllers/schedule_report_controller.dart';

class ScheduleReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleReportController>(
      () => ScheduleReportController(),
    );
  }
}
