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

import '../../../../l10n/app_localizations.dart';
import '../controllers/apply_leave_page_controller.dart';

class ApplyLeavePageView extends GetView<ApplyLeavePageController> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(AppLocalizations.of(context)!.applyLeave),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          16.height,
          Text(AppLocalizations.of(context)!.selectLeaveType),
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
                  l10n.selectStartDate,
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
                  l10n.selectEndDate,
              suffixIcon: const Icon(
                Icons.date_range,
                color: AppColors.kBlue600,
              ),
            );
          }),
          24.height,
          AppTextField(
            hintText: AppLocalizations.of(context)!.reasonForLeave,
            controller: controller.leavereasonTC,
          ),
          24.height,
          Text(AppLocalizations.of(context)!.selectApprovalPerson),
          Obx(() {
            if (controller.isTeamLoading.value) {
              return const UnconstrainedBox(child: CircularProgressIndicator());
            }
            if (controller.adminMembers.isEmpty) {
              return Text(AppLocalizations.of(context)!.noAdminMembersFound);
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
            label: l10n.submit,
          )
        ],
      ),
    );
  }

  Future<void> openDatePickerdialog(
      bool isStartDate, BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final companyworkingdays =
        workingDays(AppStorageController.to.currentUser?.wrokingDays ?? []);

    final now = ServerTime.now;

    // ✅ Calculate firstDate (earliest selectable date)
    final DateTime firstDate =
        isStartDate ? now : (controller.leaveStartDate.value ?? now);

    // ✅ Calculate desired initial date
    DateTime initialDate = isStartDate
        ? (controller.leaveStartDate.value ?? now)
        : (controller.leaveEndDate.value ??
            controller.leaveStartDate.value ??
            now);

    // ✅ Make sure initialDate is not before firstDate
    if (initialDate.isBefore(firstDate)) {
      initialDate = firstDate;
    }

    // ✅ If initialDate is not a working day, find the next valid working day
    int safety = 0;
    while (!companyworkingdays.contains(initialDate.weekday) && safety < 30) {
      initialDate = initialDate.add(const Duration(days: 1));
      safety++;
    }

    // ✅ Safety check — if no valid working day found, show error and exit
    if (!companyworkingdays.contains(initialDate.weekday)) {
      showErrorSnack(l10n.noWorkingDaysConfigured);
      return;
    }

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now.add(const Duration(days: 365 * 2)),
      initialDate: initialDate,
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
