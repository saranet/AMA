import 'package:ama/app/models/Branches.dart';
import 'package:ama/app/models/Departments.dart';
import 'package:ama/app/modules/LoginPage/controllers/login_page_controller.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:ama/utils/theme/app_fonts.dart';
import 'package:ama/utils/theme/app_theme.dart';
import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';
import 'package:ama/widgets/GradientButton.dart';
import 'package:ama/widgets/app_button.dart';
import 'package:ama/widgets/app_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../utils/theme/app_colors.dart';
import '../controllers/sign_up_page_controller.dart';

class SignUpPageView extends GetView<SignUpPageController> {
  const SignUpPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              24.height,
              Text(
                "Register Account",
                style: Get.textTheme.headlineLarge,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "to",
                      style: Get.textTheme.headlineLarge,
                    ),
                    TextSpan(
                      text: " HR Attendance ",
                      style: Get.textTheme.headlineLarge?.copyWith(
                        color: AppColors.kBlue900,
                      ),
                    ),
                  ],
                ),
              ),
              16.height,
              Text(
                "Hello there, Sign Up to Continue",
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: AppColors.kGrey300,
                ),
              ),
              16.height,
              AppTextField(
                hintText: "Full Name",
                controller: controller.fullNameTc,
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return "This field can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              16.height,
              AppTextField(
                hintText: "Email Address",
                controller: controller.emailTc,
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return "This field can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              16.height,
              AppTextField(
                hintText: " Password",
                isPassword: true,
                controller: controller.passwordTc,
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return "This field can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              16.height,
              Obx(() {
                if (controller.branches.isEmpty) {
                  return const Text("No Branch Found");
                }
                return DropdownButton<Branch>(
                  value: controller.selectedItem.value,
                  hint: Text("Select Branch"),
                  items: controller.branches
                      .map((item) => DropdownMenuItem<Branch>(
                            value: item,
                            child: Text(item
                                .name), // Assuming Branch has a 'name' property
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.onBranchSelected(value);
                  },
                  isExpanded: true,
                );
              }),
              16.height,
              Obx(() {
                // Show departments only if branch selected
                if (controller.selectedItem.value == null) {
                  return const SizedBox(); // nothing before branch
                }
                if (controller.departments.isEmpty) {
                  return const Text("No Department Found");
                }
                return DropdownButton<Departments>(
                  value: controller.selectedDepartment.value,
                  hint: Text("Select Department"),
                  items: controller.departments
                      .map((item) => DropdownMenuItem<Departments>(
                            value: item,
                            child: Text(item
                                .name), // Assuming Department has a 'name' property
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedDepartment.value = value;
                  },
                  isExpanded: true,
                );
              }),
              16.height,
              Obx(() {
                return SwitchListTile(
                  activeColor: Color(0xFF008FBF), // Thumb color when ON
                  activeTrackColor:
                      Color(0xFF008FBF).withOpacity(0.5), // Track color when ON
                  dense: true,
                  value: controller.isEmployeeSignup.value,
                  onChanged: (value) =>
                      controller.isEmployeeSignup.value = value,
                  title: Text(
                    controller.isEmployeeSignup.value
                        ? "Employee SignUp"
                        : "Admin SignUp",
                    style: Get.textTheme.bodyLarge,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }),
              /*Obx(() {
                return Visibility(
                  visible: !controller.isEmployeeSignup.value,
                  replacement: Column(
                    children: [],
                  ),
                  child: Column(
                    children: [
                      title("Organization Details", Icons.people_alt_outlined),
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
                            color: AppColors.kBlue900,
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
                            color: AppColors.kBlue900,
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
                                    selectedColor: AppColors.kBlue900,
                                    label: Text(
                                      controller.workingDays[index].label,
                                      style: Get.textTheme.bodySmall?.copyWith(
                                        color: controller
                                                .workingDays[index].isSelected
                                            ? AppColors.kWhite
                                            : AppColors.black,
                                      ),
                                    ),
                                    selected: controller
                                        .workingDays[index].isSelected,
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
                      AppTextField(
                        hintText: "Per Month Paid Leave",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: controller.paidLeaveTC,
                      ),
                      16.height,
                      AppTextField(
                        hintText: "Per Month Sick/Casual Leave",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: controller.casualSickTC,
                      ),
                      16.height,
                      AppTextField(
                        hintText: "Per Month Work From Home",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        controller: controller.wfhTC,
                      ),
                    ],
                  ),
                );
              }),*/
              30.height,
              Obx(() {
                return Column(
                  children: [
                    GradientButton(
                      onPressed: controller.signUP,
                      label: "Signup",
                      isLoading: controller.isSaveLoading.value,
                    ),
                    16.height,
                    // Fingerprint setup prompt (optional)
                    FutureBuilder(
                      future: controller.secureStorage.read(key: 'username'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          // Show fingerprint login button
                          return Column(
                            children: [
                              Text(
                                "You can login later with fingerprint",
                                style: Get.textTheme.bodySmall,
                              ),
                              IconButton(
                                onPressed: () => Get.find<AuthController>()
                                    .loginWithBiometrics(),
                                icon: Icon(
                                  Icons.fingerprint,
                                  size: 40,
                                  color: AppColors.kBlue900,
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                );
              }),
              16.height,
              Align(
                alignment: Alignment.topCenter,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Do you have an account ? ",
                        style: Get.textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: " Login",
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppColors.kBlue900,
                          fontWeight: AppFontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = controller.gotToLoginPage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget title(String name, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(name, style: Get.textTheme.titleLarge),
          const SizedBox(
            width: 10,
          ),
          Icon(
            iconData,
            size: 20,
            color: AppColors.kBlue900,
          ),
        ],
      ),
    );
  }
}
