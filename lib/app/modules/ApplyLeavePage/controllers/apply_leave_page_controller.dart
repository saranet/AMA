import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/models/team_members_model.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';

import '../../../../l10n/app_localizations.dart';

class ApplyLeavePageController extends GetxController {
  var leavereasonTC = TextEditingController();
  var leaveStartDate = Rxn<DateTime?>(), leaveEndDate = Rxn<DateTime?>();
  var adminMembers = <MembersData>[];
  MembersData? selectedTeam;
  LeaveType? selectedLeaveType;
  var isTeamLoading = true.obs;

  // Shortcut to access translations anywhere in this controller
  AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchAllAdminMembers();
  }

  void goBack() {
    if (Get.previousRoute.isEmpty) {
      Get.offAllNamed(AppPages.INITIAL);
    } else {
      Get.back();
    }
  }

  void appllyLeave() {
    if (selectedTeam == null ||
        leavereasonTC.text.trim().isEmpty ||
        selectedLeaveType == null) {
      showErrorSnack(l10n.selectApprovalPersonAndReasonAndType);
      return;
    }
    ApiController.to.callPOSTAPI(
      url: APIUrlsService.to.addLeave,
      body: {
        "userID": AppStorageController.to.currentUser?.userID,
        "companyID": AppStorageController.to.currentUser?.companyID,
        "approvalTo": selectedTeam?.id,
        "leaveStatus": "PENDING",
        "fromdate": leaveStartDate.value?.toYYYMMDD,
        "todate": leaveEndDate.value?.toYYYMMDD,
        "leaveReason": leavereasonTC.text,
        "leaveType": selectedLeaveType?.code,
      },
    ).then((resp) {
      if (resp != null && resp is Map<String, dynamic> && resp['status']) {
        leavereasonTC.clear();
        leaveStartDate.value = null;
        leaveEndDate.value = null;
        goBack();
      } else {
        showErrorSnack((resp['errorMsg'] ?? resp).toString());
      }
    }).catchError((e) {
      showErrorSnack(e.toString());
    });
  }

  Future<void> fetchAllAdminMembers() async {
    if (!isTeamLoading.value) {
      isTeamLoading.value = true;
    }

    try {
      final resp = await ApiController.to.callGETAPI(
        url: APIUrlsService.to.fetchAllAdminManagerByCompany(
          AppStorageController.to.currentUser!.companyID!,
          AppStorageController.to.currentUser!.userID!,
          AppStorageController.to.currentUser!.departmentID!,
        ),
      );

      if (resp != null && resp is Map) {
        if (resp['status'] == true && resp['data'] is List) {
          adminMembers.clear();
          adminMembers.addAll(
            (resp['data'] as List).map((e) => MembersData.fromJson(e)).toList(),
          );
          if (adminMembers.isNotEmpty) {
            selectedTeam = adminMembers.first;
          }
        } else {
          final errMsg = (resp['errorMsg'] ?? l10n.unknownError).toString();
          //showErrorSnack(errMsg);
        }
      } else {
        showErrorSnack(l10n.invalidResponseFromServer);
      }
    } catch (e) {
      showErrorSnack(e.toString());
    } finally {
      // ✅ Always reset loading — fixes infinite spinner
      isTeamLoading.value = false;
    }
  }

  @override
  void onClose() {
    leavereasonTC.dispose();
    super.onClose();
  }
}
