import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/app/modules/HomePage/views/user_activity_view.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/widgets/horizontal_date.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attend_report_controller.dart';

class AttendReportView extends GetView<AttendReportController> {
  const AttendReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Attendance Report"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          //? User Profile
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(minRadius: 35),
                16.width,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName ?? '-',
                      style: Get.textTheme.headlineMedium,
                    ),
                    Text(
                      AppStorageController.to.currentUser!.departmentName ??
                          '-',
                      style: Get.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active_outlined),
                )
              ],
            ),
          ),
          12.height,
          //? Date Picker
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return HorizontalDate(
                fromDate: DateTime.now(),
                toDate: DateTime.now().subtract(const Duration(days: 10)),
                selectedDate: controller.selectedDate.value,
                onTap: controller.onDateChnged,
              );
            }),
          ),

          20.height,
          //? Your Activity View All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("User Activity", style: Get.textTheme.headlineSmall),
          ),

          20.height,

          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return UserActivityView(
                  userActivityModel: controller.userActivityModel.value,
                );
              })),

          60.height,
        ],
      ),
    );
  }
}
