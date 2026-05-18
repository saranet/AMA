import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/app/modules/HomePage/views/user_activity_view.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/widgets/horizontal_date.dart';
import 'package:ama/widgets/swipebutton/swipe_button.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
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
                      AppStorageController.to.currentUser?.fullName ?? '-',
                      style: Get.textTheme.headlineMedium,
                    ),
                    Text(
                      AppStorageController.to.currentUser?.departmentName ??
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
                fromDate: ServerTime.now,
                toDate: ServerTime.now.subtract(const Duration(days: 10)),
                selectedDate: controller.selectedDate.value,
                onTap: controller.onDateChnged,
              );
            }),
          ),
          28.height,
          //? Today Attendance Text
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text(l10n.todayAttendence, style: Get.textTheme.headlineSmall),
                16.width,
                if (AppStorageController.to.currentUser?.roleType ==
                        UserRoleType.admin ||
                    AppStorageController.to.currentUser?.roleType ==
                        UserRoleType.manager ||
                    AppStorageController.to.currentUser?.roleType ==
                        UserRoleType.superAdmin) ...[
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.HOME_ANALYTICS);
                    },
                    icon: const Icon(Icons.analytics_outlined),
                  ),
                  20.width,
                ],
                Obx(
                  () {
                    return controller.attendenceLoading.value
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: AppColors.kBlue900,
                              strokeWidth: 1.5,
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
          8.height,
          //? Check In && Check Out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() {
                    final checkIns =
                        controller.userActivityModel.value?.checkIn;
                    String time = "-";
                    String msg = "";

                    if (checkIns != null && checkIns.isNotEmpty) {
                      time = DateFormat("HH:mm:ss")
                          .parse(checkIns.first.inTime!)
                          .tohhMMh;
                      msg = _translateMsg(checkIns.first.msg, l10n);
                    }

                    return _buildCheckInOutCard(
                      Icons.input_rounded,
                      l10n.checkIn,
                      time,
                      msg,
                    );
                  }),
                ),
                10.width,
                Expanded(
                  child: Obx(() {
                    final outTimes =
                        controller.userActivityModel.value?.outTime;
                    String time = "-";
                    String msg = "";

                    if (outTimes != null && outTimes.isNotEmpty) {
                      time = DateFormat("HH:mm:ss")
                          .parse(outTimes.last.outTime!)
                          .tohhMMh;
                      msg = _translateMsg(outTimes.last.msg, l10n);
                    }

                    return _buildCheckInOutCard(
                      Icons.logout_rounded,
                      l10n.checkOut,
                      time,
                      msg,
                    );
                  }),
                ),
              ],
            ),
          ),

          8.height,
          //? Break Time && Total Days
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                    () {
                      return _buildCheckInOutCard(
                        Icons.free_breakfast_outlined,
                        l10n.breakTime,
                        controller.calculateTimeDifference(
                                controller.attendenceModel.value?.breakInTime,
                                controller
                                    .attendenceModel.value?.breakOutTime) ??
                            '-',
                        "",
                      );
                    },
                  ),
                ),
                10.width,
                Expanded(
                  child: _buildCheckInOutCard(
                    Icons.calendar_today_outlined,
                    l10n.totalDays,
                    '0',
                    l10n.workingDays,
                  ),
                ),
              ],
            ),
          ),
          //? Total Working Time
          Obx(
            () {
              if (controller.workingTime.isEmpty) {
                return const SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.all(16),
                child: _buildCheckInOutCard(
                  Icons.work_history_outlined,
                  l10n.totalWorkingHours,
                  controller.workingTime.value,
                  '-',
                ),
              );
            },
          ),
          20.height,
          //? Your Activity View All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.yourActivity, style: Get.textTheme.headlineSmall),
          ),
          20.height,
          //? Swipe Button (with duplicate-prevention)
          Obx(() {
            final actions = controller.userPerformActivties;
            final isToday = controller.selectedDate.value.year ==
                    controller.now.year &&
                controller.selectedDate.value.month == controller.now.month &&
                controller.selectedDate.value.day == controller.now.day;

            if (!isToday || actions.isEmpty) {
              return const SizedBox();
            }

            // ✅ Watch processing state
            final isProcessing = controller.isPerformingAction.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: actions.map((action) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SwipeButton.expand(
                      // ✅ Disable during processing
                      enabled: !isProcessing,
                      // ✅ Show spinner while processing
                      thumb: isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.double_arrow_rounded,
                              color: Colors.white,
                            ),
                      thumbPadding: const EdgeInsets.all(6),
                      height: 58,
                      borderRadius: borderRadius,
                      activeThumbColor: AppColors.kBlue900,
                      activeTrackColor: AppColors.kBlue600,
                      inactiveThumbColor: AppColors.kGrey300,
                      inactiveTrackColor: AppColors.kGrey100,
                      // ✅ onSwipe is null when processing
                      onSwipe: isProcessing
                          ? null
                          : controller.available
                              ? () => controller.authController
                                      .authenticateAndRun(() {
                                    controller.performInOut(action);
                                  })
                              : () => controller.performInOut(action),
                      child: Text(
                        isProcessing ? l10n.processing : action.label,
                        style: Get.textTheme.titleSmall,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),

          20.height,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              return UserActivityView(
                userActivityModel: controller.userActivityModel.value,
              );
            }),
          ),
          28.height,
          60.height,
        ],
      ),
    );
  }

  Widget _buildCheckInOutCard(
    IconData iconData,
    String title,
    String time,
    String description,
  ) {
    return DecoratedBox(
      decoration: kBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.kBlue600,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      iconData,
                      size: 20,
                    ),
                  ),
                ),
                10.width,
                Text(
                  title,
                  style: Get.textTheme.bodyLarge,
                )
              ],
            ),
            8.height,
            Text(
              time,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              description,
              style: Get.textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }

  String _translateMsg(String? msg, AppLocalizations l10n) {
    if (msg == null || msg.trim().isEmpty) return '';

    final normalized = msg.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

    switch (normalized) {
      case 'late':
        return l10n.msgLate;
      case 'on time':
      case 'ontime':
        return l10n.msgOnTime;
      case 'over time':
      case 'overtime':
        return l10n.msgOverTime;
      case 'early':
        return l10n.msgEarly;
      case 'early checkout':
      case 'earlycheckout':
        return l10n.msgEarlyCheckout;
      default:
        return msg;
    }
  }
}
