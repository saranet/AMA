import 'package:ama/widgets/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/widgets/app_button.dart';
import 'package:ama/widgets/app_textfield.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  const ProfilePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          30.height,
          title(l10n.userDetails, Icons.person),
          16.height,
          title(l10n.fullName, Icons.person),
          AppTextField(
            hintText: l10n.fullName,
            controller: TextEditingController(
              text: AppStorageController.to.currentUser!.fullName ?? '',
            ),
            readOnly: true,
          ),
          title(l10n.userName, Icons.person),
          AppTextField(
            hintText: l10n.userName,
            controller: TextEditingController(
              text: controller.userName.text,
            ),
            readOnly: true,
          ),
          title(l10n.branchDetails, Icons.person),
          AppTextField(
            hintText: l10n.branchName,
            controller: TextEditingController(
              text: AppStorageController.to.currentUser!.branchName ?? '',
            ),
            readOnly: true,
          ),
          title(l10n.departmentDetails, Icons.badge_outlined),
          AppTextField(
            hintText: l10n.departmentName,
            controller: TextEditingController(
              text: AppStorageController.to.currentUser!.departmentName ?? '',
            ),
            readOnly: true,
          ),
          16.height,
          GradientButton(
            onPressed: () => showResetPasswordDialog(context),
            label: l10n.updatePassword,
          ),
          16.height,
          GradientButton(
            padding: const EdgeInsets.all(10.0),
            onPressed: AppStorageController.to.logout,
            label: l10n.logOut,
          ),
          if (AppStorageController.to.currentUser?.roleType ==
              UserRoleType.superAdmin) ...[
            36.height,
            organizationDetails(context),
          ],
        ],
      ),
    );
  }

  Future<void> showResetPasswordDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    String password = "", renterPassword = "";
    bool isProcessing = false;
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

// Read in an async function
    String? old_pass = await secureStorage.read(key: 'password');
    Get.defaultDialog(
      title: l10n.setNewPassword,
      barrierDismissible: false,
      content: Column(
        children: [
          24.height,
          AppTextField(
            hintText: l10n.enterNewPassword,
            onChanged: (p) => password = p,
          ),
          24.height,
          AppTextField(
            hintText: l10n.reenterNewPassword,
            onChanged: (p) => renterPassword = p,
          ),
          24.height,
        ],
      ),
      textCancel: l10n.cancel,
      onCancel: closeDialogs,
      textConfirm: l10n.updatePassword,
      onConfirm: () async {
        // ✅ Prevent double-tap
        if (isProcessing) return;

        // ✅ Better validation
        if (password.trim().isEmpty) {
          showErrorSnack(l10n.enterNewPassword);
          return;
        }
        if (renterPassword.trim().isEmpty) {
          showErrorSnack(l10n.reenterNewPassword);
          return;
        }
        if (password.trim() != renterPassword.trim()) {
          showErrorSnack(l10n.pleaseEnterCorrectPassword);
          return;
        }

        isProcessing = true;
        print('passssssssssssssss: $old_pass');

        try {
          final resp = await ApiController.to.callGETAPI(
            url: APIUrlsService.to.updatePassword(
              controller.userName.text,
              old_pass ?? "",
              renterPassword,
            ),
          );

          print('🔐 API response: $resp');

          // ✅ Handle ALL possible response cases
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['status'] == true) {
            Get.back(); // close the dialog
            showSuccessSnack(l10n.passwordUpdatedSuccessfullyPleaseLoginAgain);
          } else {
            // ✅ Show the actual error from the server
            final errorMsg = (resp is Map && resp['errorMsg'] != null)
                ? resp['errorMsg'].toString()
                : l10n.unknownError;
            showErrorSnack(errorMsg);
          }
        } catch (e) {
          // ✅ Catch network/parse errors
          print('🔐 Error: $e');
          showErrorSnack(e.toString());
        } finally {
          isProcessing = false;
        }
      },
    );
  }

  Widget title(String name, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 0),
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

  Widget organizationDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        title(l10n.organizationDetails, Icons.people_alt_outlined),
        16.height,
        AppTextField(
          hintText: l10n.organizationName,
          controller: controller.organizationTC,
          validator: (val) {
            if (val?.isEmpty ?? true) {
              return l10n.thisFieldCantBeEmpty;
            } else {
              return null;
            }
          },
        ),
        16.height,
        Obx(() {
          return AppButton.appOutlineButtonRow(
            onPressed: () => openTimePickerdialog(true, context),
            label: controller.startTime.value == null
                ? l10n.selectStartTime
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
                ? l10n.selectEndTime
                : formatTimeOfDay(controller.endTime.value!),
            suffixIcon: const Icon(
              Icons.access_time_outlined,
              color: AppColors.kBlue600,
            ),
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
                          color: controller.workingDays[index].isSelected
                              ? AppColors.kWhite
                              : AppColors.black,
                        ),
                      ),
                      selected: controller.workingDays[index].isSelected,
                      onSelected: (value) =>
                          controller.onWorkingDaysChange(index),
                    ),
                  ).toList(),
                );
              }),
            ),
          ),
        ),
        16.height,
        FilledButton(
          onPressed: controller.updateCompany,
          child: Text(l10n.updateOrganization),
        ),
        50.height,
      ],
    );
  }
}
