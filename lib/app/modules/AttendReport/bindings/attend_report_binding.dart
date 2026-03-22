import 'package:get/get.dart';

import '../controllers/attend_report_controller.dart';

class AttendReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendReportController>(
      () => AttendReportController(),
    );
  }
}
