import 'package:ama/app/modules/ScheduleReport/model/schedule_model.dart';
import 'package:ama/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/modules/LeavePage/model/leave_activity_model.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/widgets/leave_activity_card.dart';

import 'package:get/get.dart';

import '../controllers/schedule_report_controller.dart';

class ScheduleReportView extends GetView<ScheduleReportController> {
  const ScheduleReportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kWhite,
          title: const Text("All Schedules"),
          actions: [
            IconButton.outlined(
              onPressed: controller.getAllSchedules,
              icon: const Icon(Icons.refresh),
            ),
            4.width,
            if (AppStorageController.to.currentUser?.roleType ==
                    UserRoleType.admin ||
                AppStorageController.to.currentUser?.roleType ==
                    UserRoleType.manager) ...[
              Obx(
                () {
                  return Row(
                    children: [
                      IconButton.outlined(
                        onPressed: () => Get.toNamed(Routes.SCHEDULES_PAGE),
                        icon: const Icon(Icons.add),
                      ),
                      4.width,
                      Text(controller.myData.value ? "My" : "Other"),
                      4.width,
                      Switch(
                        activeTrackColor: Color(0xFF008FBF),
                        value: controller.myData.value,
                        onChanged: controller.myDataChanged,
                      ),
                    ],
                  );
                },
              ),
              14.width,
            ],
          ],
        ),
        body: ListView(
          children: [
            20.height,
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  final schedules =
                      controller.scheduleModel; // RxList<ScheduleModel>

                  if (schedules.isEmpty) {
                    return const Center(child: Text("No schedules found"));
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: (controller.myData.value)
                            ? Text("My Schedule",
                                style: Get.textTheme.headlineSmall)
                            : Text("Other Schedules",
                                style: Get.textTheme.headlineSmall),
                      ),
                      12.height,
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: scheduleView(context, schedule),
                          );
                        },
                      ),
                    ],
                  );
                })),
            60.height,
          ],
        ));
  }

  Widget scheduleView(BuildContext context, ScheduleModel? scheduleModel) {
    if (scheduleModel == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Schedule Info
        Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheduleModel.slug ?? "No Title",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("ID: ${scheduleModel.id ?? "-"}"),
                Text("Created By: ${scheduleModel.created_by ?? "-"}"),
                Text("Created At: ${scheduleModel.created_at ?? "-"}"),
                const Divider(height: 20),

                // Users
                if (scheduleModel.usersName != null &&
                    scheduleModel.usersName!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Assigned Users:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...scheduleModel.usersName!.map((u) => Text("- $u")),
                    ],
                  ),

                const SizedBox(height: 10),

                // In / Out Times
                if (scheduleModel.inTime != null)
                  Row(
                    children: [
                      const Icon(Icons.login, color: Colors.green),
                      const SizedBox(width: 8),
                      Text("In Time: ${scheduleModel.inTime}"),
                    ],
                  ),
                if (scheduleModel.outTime != null)
                  Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.red),
                      const SizedBox(width: 8),
                      Text("Out Time: ${scheduleModel.outTime}"),
                    ],
                  ),

                const SizedBox(height: 10),

                // Working Days
                if (scheduleModel.workingDays != null &&
                    scheduleModel.workingDays!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Working Days:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: scheduleModel.workingDays!
                            .map((day) => Chip(label: Text(day)))
                            .toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

/*  Widget arrangeInOutList(List<String> inTimes, List<String> outTimes) {
    var newList = mergeBreakInBreakOutTimes(inTimes, outTimes);
    print(newList);
    return Column(
      children: [
        for (int i = 0; i < newList.length; i++) ...[
          if (i.isEven) ...{
            16.height,
            ActivityCard(
              iconData: Icons.free_breakfast_outlined,
              title: "Break In",
              dateTime: DateFormat("HH:mm:ss yyyy-MM-dd")
                  .parse("${newList[i]} ${userActivityModel!.createdAt!}"),
              description: "",
            ),
          } else ...[
            16.height,
            ActivityCard(
              iconData: Icons.free_breakfast_outlined,
              title: "Break Out",
              dateTime: DateFormat("HH:mm:ss yyyy-MM-dd")
                  .parse("${newList[i]} ${userActivityModel!.createdAt!}"),
              description: "",
            ),
          ],
        ],
      ],
    );
  }*/
}
