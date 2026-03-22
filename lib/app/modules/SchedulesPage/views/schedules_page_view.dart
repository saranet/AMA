import 'package:ama/app/modules/SchedulesPage/controllers/schedules_page_controller.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/widgets/GradientButton.dart';
import 'package:ama/widgets/app_button.dart';
import 'package:ama/widgets/app_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../models/team_members_model.dart';
import '../../../models/teams_model.dart';

class SchedulesPageView extends GetView<SchedulesPageController> {
  const SchedulesPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.goBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Add Schedule'),
        actions: [
          IconButton.outlined(
            onPressed: () {}, //controller.getAllLeaves,
            icon: const Icon(Icons.schedule_outlined),
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Column(
                children: [
                  16.height,
                  AppTextField(
                    hintText: "Schedule Name",
                    controller: controller.scheduleNameTC,
                  ),
                  16.height,
                  Obx(() {
                    return AppButton.appOutlineButtonRow(
                      onPressed: () => openTimePickerdialog(true, context),
                      label: controller.startTime.value == null
                          ? "Select start time"
                          : formatTimeOfDay(controller.startTime.value!),
                      suffixIcon: const Icon(
                        Icons.access_time_outlined,
                        color: AppColors.kBlue600,
                      ),
                    );
                  }),
                  16.height,
                  Obx(() {
                    return AppButton.appOutlineButtonRow(
                      onPressed: () => openTimePickerdialog(false, context),
                      label: controller.endTime.value == null
                          ? "Select end time"
                          : formatTimeOfDay(controller.endTime.value!),
                      suffixIcon: const Icon(
                        Icons.access_time_outlined,
                        color: AppColors.kBlue600,
                      ),
                    );
                  }),
                  16.height,
                  Obx(() {
                    if (controller.isTeamLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.teams.isEmpty) {
                      return const Center(
                        child: Text("No Teams Found"),
                      );
                    }
                    return DropdownButton<TeamsModel>(
                      items: controller.teams
                          .map(
                            (e) => DropdownMenuItem<TeamsModel>(
                              value: e,
                              child: Text(e.teamName ?? "?"),
                            ),
                          )
                          .toList(),
                      value: controller.selectedTeam,
                      onChanged: (a) {
                        controller.selectedTeam = a!;
                        controller.isTeamLoading.refresh();
                      },
                    );
                  }),
                  16.height,
                  DecoratedBox(
                    decoration: kBoxDecoration,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Obx(() {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 15,
                            children: List.generate(
                              controller.workingDays.value.length,
                              (index) => ChoiceChip(
                                label: Text(
                                  controller.workingDays[index].label,
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    color:
                                        controller.workingDays[index].isSelected
                                            ? AppColors.kWhite
                                            : AppColors.black,
                                  ),
                                ),
                                selected:
                                    controller.workingDays[index].isSelected,
                                onSelected: (value) =>
                                    controller.onWorkingDaysChange(index),
                              ),
                            ).toList(),
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ),
              20.height,
              GradientButton(
                padding: const EdgeInsets.all(16.0),
                onPressed: controller.add_schedule,
                label: "Add Schedule",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget title(String name, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: Get.textTheme.titleLarge,
          ),
          const SizedBox(width: 10),
          Icon(
            iconData,
            size: 20,
            color: AppColors.kBlue600,
          )
        ],
      ),
    );
  }

  Future<void> openTimePickerdialog(
      bool isStartTime, BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      if (isStartTime) {
        controller.startTime.value = selectedTime;
      } else {
        controller.endTime.value = selectedTime;
      }
    }
  }
}
