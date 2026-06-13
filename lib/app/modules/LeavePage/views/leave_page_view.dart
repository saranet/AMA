import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/modules/LeavePage/model/leave_activity_model.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/widgets/leave_activity_card.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/leave_page_controller.dart';

class LeavePageView extends GetView<LeavePageController> {
  const LeavePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kWhite,
        title: Text(l10n.allLeaves),
        actions: [
          IconButton.outlined(
            onPressed: controller.getAllLeaves,
            icon: const Icon(Icons.refresh),
          ),
          14.width,
          if (AppStorageController.to.currentUser?.roleType !=
              UserRoleType.superAdmin) ...[
            Row(
              children: [
                IconButton.outlined(
                  onPressed: () => Get.toNamed(Routes.APPLY_LEAVE_PAGE),
                  icon: const Icon(Icons.add),
                ),
                14.width,
              ],
            ),
          ],
          if (AppStorageController.to.currentUser?.roleType ==
                  UserRoleType.admin ||
              AppStorageController.to.currentUser?.roleType ==
                  UserRoleType.manager) ...[
            Obx(
              () {
                return Row(
                  children: [
                    Text(controller.myData.value ? l10n.my : l10n.other),
                    4.width,
                    Switch(
                      activeTrackColor: const Color(0xFF008FBF),
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
      body: Column(
        children: [
          Obx(
            () {
              return (controller.totalCount.isNotEmpty)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildOverViewLeave(
                              l10n.leave,
                              controller.totalCount['paidLeaveBalance'],
                              AppColors.kBlue900,
                              prefixLabel: l10n.paid,
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: _buildOverViewLeave(
                              l10n.leave,
                              controller
                                  .totalCount['casualAndSickLeaveBalance'],
                              AppColors.kBlue900,
                              prefixLabel: l10n.casualSick,
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: _buildOverViewLeave(
                              l10n.balance,
                              controller.totalCount['totalWFHbalance'],
                              AppColors.kOrange500,
                              prefixLabel: l10n.wfh,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox();
            },
          ),
          14.height,
          _buildTabs(),
          Expanded(
            child: _buildLeavList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOverViewLeave(String label, int? count, Color color,
      {String? prefixLabel}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prefixLabel ?? "",
            style: Get.textTheme.bodyLarge,
          ),
          Text(
            label,
            style: Get.textTheme.bodyLarge,
          ),
          5.height,
          Text(
            (count ?? '-').toString(),
            style: Get.textTheme.headlineSmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeavList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      return (controller.leaveActivities.isEmpty)
          ? Center(
              child: Text(l10n.noDataFound),
            )
          : ListView.builder(
              itemCount: controller.leaveActivities.length,
              itemBuilder: (context, index) {
                return LeaveActivityCard(
                  item: controller.leaveActivities[index],
                  approveRejectTap: (status) =>
                      controller.handleApproveRejectTap(
                    status,
                    controller.leaveActivities[index],
                  ),
                );
              },
            );
    });
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        controller.leaveActivities.value;
        return Row(
          // ✅ Iterate over enum values instead of hardcoded strings
          children: LeaveActivityState.all.map(
            (state) {
              final bool isSelected = controller.tabSelected.value == state;

              final count = controller.mainList
                  .where((element) => element.leaveStatus == state)
                  .length;

              return Expanded(
                child: InkWell(
                  onTap: () => controller.onTabChange(state),
                  borderRadius: BorderRadius.circular(16),
                  child: Ink(
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.kBlue900 : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        // ✅ Use translated label + count
                        "${state.label}${count == 0 ? '' : ' $count'}",
                        style: Get.textTheme.bodyLarge?.copyWith(
                          color:
                              isSelected ? AppColors.kWhite : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ).toList(),
        );
      }),
    );
  }
}
