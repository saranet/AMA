import 'package:ama/widgets/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/models/team_members_model.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/widgets/app_button.dart';
import 'package:ama/widgets/app_textfield.dart';

import '../controllers/apply_leave_page_controller.dart';

class ApplyLeavePageView extends GetView<ApplyLeavePageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Apply Leave"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          16.height,
          const Text("Select Leave Type"),
          StatefulBuilder(builder: (context, s) {
            return DropdownButton<String>(
              items: LeaveType.list
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              value: controller.selectedLeaveType?.readableName,
              isExpanded: true,
              onChanged: (a) {
                controller.selectedLeaveType = LeaveType.fromString(a!);
                s(() {});
              },
            );
          }),
          24.height,
          Obx(() {
            return AppButton.appOutlineButtonRow(
              onPressed: () => openDatePickerdialog(true, context),
              label: controller.leaveStartDate.value?.toMMDDYYYY ??
                  "Select start date",
              suffixIcon: const Icon(
                Icons.date_range,
                color: AppColors.kBlue600,
              ),
            );
          }),
          24.height,
          Obx(() {
            return AppButton.appOutlineButtonRow(
              onPressed: () => openDatePickerdialog(false, context),
              label: controller.leaveEndDate.value?.toMMDDYYYY ??
                  "Select end date",
              suffixIcon: const Icon(
                Icons.date_range,
                color: AppColors.kBlue600,
              ),
            );
          }),
          24.height,
          AppTextField(
            hintText: "Reason for leave",
            controller: controller.leavereasonTC,
          ),
          24.height,
          const Text("Select Approval Person"),
          Obx(() {
            if (controller.isTeamLoading.value) {
              return const UnconstrainedBox(child: CircularProgressIndicator());
            }
            if (controller.adminMembers.isEmpty) {
              return const Text("No Admin Members Found");
            }
            return DropdownButton<MembersData>(
              items: controller.adminMembers
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e.fullName ?? ""),
                    ),
                  )
                  .toList(),
              value: controller.selectedTeam,
              onChanged: (a) {
                controller.selectedTeam = a;
              },
              isExpanded: true,
            );
          }),
          16.height,
          GradientButton(
            onPressed: controller.appllyLeave,
            label: "Submit",
          )
        ],
      ),
    );
  }

  Future<void> openDatePickerdialog(
      bool isStartDate, BuildContext context) async {
    final companyworkingdays =
        workingDays(AppStorageController.to.currentUser?.wrokingDays ?? []);

    final now = DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: isStartDate
          ? now // start date can't be before today
          : controller.leaveStartDate.value ??
              now, // end date can't be before start
      lastDate: now.add(const Duration(days: 365 * 2)),
      initialDate: isStartDate
          ? (controller.leaveStartDate.value ?? now)
          : (controller.leaveEndDate.value ??
              controller.leaveStartDate.value ??
              now),
      selectableDayPredicate: (day) {
        return companyworkingdays.contains(day.weekday);
      },
    );

    if (selectedDate != null) {
      if (isStartDate) {
        controller.leaveStartDate.value = selectedDate;

        // reset end date if it's before new start date
        if (controller.leaveEndDate.value != null &&
            controller.leaveEndDate.value!.isBefore(selectedDate)) {
          controller.leaveEndDate.value = null;
        }
      } else {
        controller.leaveEndDate.value = selectedDate;
      }
    }
  }
}
