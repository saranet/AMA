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

class ApplyLeavePageController extends GetxController {
  var leavereasonTC = TextEditingController();
  var leaveStartDate = Rxn<DateTime?>(), leaveEndDate = Rxn<DateTime?>();
  var adminMembers = <MembersData>[];
  MembersData? selectedTeam;
  LeaveType? selectedLeaveType;
  var isTeamLoading = true.obs;
  // bool canShowToDate = true;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    print("Ready to fetch admin members");
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
      showErrorSnack(
          "Select Approval Person and enter leave reason and select Leave Type");
      return;
    }
    ApiController.to.callPOSTAPI(
      url: APIUrlsService.to.addLeave,
      body: {
        "userID": AppStorageController.to.currentUser?.userID,
        "companyID": AppStorageController.to.currentUser?.companyID,
        // "departmentID": AppStorageController.to.currentUser?.departmentID,
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
    });
  }

  Future<void> fetchAllAdminMembers() async {
    if (!isTeamLoading.value) {
      isTeamLoading.value = true;
    }
    final resp = await ApiController.to
        .callGETAPI(
      url: APIUrlsService.to.fetchAllAdminManagerByCompany(
        AppStorageController.to.currentUser!.companyID!,
        AppStorageController.to.currentUser!.userID!,
        AppStorageController.to.currentUser!.departmentID!,
      ),
    )
        .catchError((e) {
      isTeamLoading.value = true;
    });

// Debug log
    // print("DEBUG RAW RESPONSE: $resp");

    if (resp != null && resp is Map) {
      if (resp['status'] == true && resp['data'] is List) {
        adminMembers.clear();
        adminMembers.addAll(
          (resp['data'] as List).map((e) => MembersData.fromJson(e)).toList(),
        );
        if (adminMembers.isNotEmpty) {
          selectedTeam = adminMembers.first;
        }
        isTeamLoading.value = false;
      } else {
        final errMsg =
            (resp['errorMsg'] ?? "Unknown error occurred").toString();
        showErrorSnack(errMsg); // always String now
      }
    } else {
      showErrorSnack("Invalid response from server");
    }
  }

  @override
  void onClose() {}
}
