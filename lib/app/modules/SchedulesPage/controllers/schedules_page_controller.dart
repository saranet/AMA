import 'package:ama/app/modules/SignUpPage/model/working_days_model.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/team_members_model.dart';
import '../../../models/teams_model.dart';

class SchedulesPageController extends GetxController {
  var workingDays = <WorkingDaysModel>[].obs;
  var teams = <TeamsModel>[];
  TeamsModel? selectedTeam;
  MemberModel? members;
  var isTeamLoading = true.obs, isMemberLoading = false.obs;

  var startTime = Rxn<TimeOfDay?>(null), endTime = Rxn<TimeOfDay?>(null);
  var formKey = GlobalKey<FormState>();
  var isSaveLoading = false.obs;
  //TODO: Implement SchedulesPageController

  final count = 0.obs;

  var scheduleNameTC = TextEditingController();

  @override
  void onInit() {
    print("onInit");
    scheduleNameTC.text = "";
    workingDays.value = <String>[
      "Monday", // MONDAY
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ]
        .map(
          (e) => WorkingDaysModel(
            label: e,
            code: e.toUpperCase(),
            isSelected: kDebugMode,
          ),
        )
        .toList();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    print("onReady");
    scheduleNameTC.text = "";
    fetchAllTeams();
  }

  void goBack() {
    if (Get.previousRoute.isEmpty) {
      Get.offAllNamed(AppPages.INITIAL);
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    print("onClose");
    super.onClose();
    scheduleNameTC.dispose();
  }

  Future<void> fetchAllTeams() async {
    if (!isTeamLoading.value) {
      isTeamLoading.value = true;
    }
    await AppStorageController.to.asyncCurrentUser;
    final resp = await ApiController.to
        .callGETAPI(
      url: APIUrlsService.to.fetchTeams(
        AppStorageController.to.currentUser!.companyID!,
        AppStorageController.to.currentUser!.departmentID!,
        AppStorageController.to.currentUser!.userID!,
        AppStorageController.to.currentUser!.roleType!.code,
      ),
    )
        .catchError((e) {
      isTeamLoading.value = true;
    });
    print("DEBUG RAW RESPONSE: $resp");
    if (resp != null && resp is Map) {
      if (resp['status'] == true && resp['data'] is List) {
        teams.clear();
        teams.addAll(
          (resp['data'] as List).map((e) => TeamsModel.fromJson(e)).toList(),
        );
        if (teams.isNotEmpty) {
          selectedTeam = teams.first;
          //fetchMembersbyTeams(selectedTeam!);
        } else {
          members = null;
          isMemberLoading.refresh();
        }
        isTeamLoading.value = false;
      } else {
        final errMsg =
            (resp['errorMsg'] ?? "Unknown error occurred").toString();
        showErrorSnack(errMsg); // always String now
      }
    } else {
      showErrorSnack((resp['errorMsg'] ?? resp).toString());
    }
  }

  onWorkingDaysChange(int index) {
    workingDays[index].isSelected = !workingDays[index].isSelected;
    workingDays.refresh();
  }

  // ignore: non_constant_identifier_names
  Future<void> add_schedule() async {
    List<WorkingDaysModel> tempWorkingdays = List.from(workingDays.value);
    tempWorkingdays.removeWhere((element) => !element.isSelected);
    workingDays.refresh();
    // print(tempWorkingdays.map((e) => e.code).toList());

    if (formKey.currentState?.validate() ?? false || !isSaveLoading.value) {
      if (scheduleNameTC.text.isEmpty ||
          startTime.value == null ||
          endTime.value == null ||
          workingDays.value.where((element) => element.isSelected).isEmpty) {
        showErrorSnack("Please Complete All Fields");
        return;
      }
      isSaveLoading.value = true;
      var payload = {};
      List<WorkingDaysModel> tempWorkingdays = List.from(workingDays.value);
      tempWorkingdays.removeWhere((element) => !element!.isSelected);

      payload = {
        "SH_Name": scheduleNameTC.text,
        "inTime": formatTimeOfDay(startTime.value!),
        "outTime": formatTimeOfDay(endTime.value!),
        "workingDays": tempWorkingdays.map((e) => e.code).toList(),
        "companyID": AppStorageController.to.currentUser!.companyID,
        "createdBy": AppStorageController.to.currentUser!.userID,
        "role": AppStorageController.to.currentUser!.roleType?.name,
        "teamID": selectedTeam?.id,
      };

      ApiController.to
          .callPOSTAPI(
        url: APIUrlsService.to.add_shedule,
        body: payload,
      )
          .then((resp) async {
        isSaveLoading.value = false;
        if (resp is Map<String, dynamic>) {
          if (resp['status'] == true) {
            // print("Schedule Created: ${resp['data']['schedule']}");
            showSuccessSnack(" Schedule Created Successfully.");
          } else {
            showErrorSnack(resp['errorMsg']?.toString() ?? "Unknown error.");
          }
        } else {
          showErrorSnack("Invalid API response format.");
        }
      }).catchError((e) {
        isSaveLoading.value = false;
        showErrorSnack((e['errorMsg'] ?? (e)).toString());
      });
    }
    goBack();
  }

  void increment() => count.value++;
}
