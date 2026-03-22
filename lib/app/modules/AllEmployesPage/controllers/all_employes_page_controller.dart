import 'package:ama/app/modules/AttendReport/bindings/attend_report_binding.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/models/team_members_model.dart';
import 'package:ama/app/models/teams_model.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/helper_function.dart';

class AllEmployesPageController extends GetxController {
  var teams = <TeamsModel>[];
  TeamsModel? selectedTeam;
  MemberModel? members;
  var isTeamLoading = true.obs, isMemberLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    AttendReportBinding().dependencies();
  }

  @override
  void onReady() {
    super.onReady();
    fetchAllTeams();
  }

  @override
  void onClose() {
    super.onClose();
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

  void onTeamTap(TeamsModel team) {
    Get.toNamed(
      Routes.ATTEND_REPORT,
      parameters: {
        "userId": team.id!,
        "userName": team.teamName!,
      },
    );
    /*fetchMembersbyTeams(team).then((e) {
      selectedTeam = team;
      isTeamLoading.refresh();
    });*/
  }

  Future<void> fetchMembersbyTeams(TeamsModel team) async {
    if (!isMemberLoading.value) {
      isMemberLoading.value = true;
    }
    final resp = await ApiController.to
        .callGETAPI(
      url: APIUrlsService.to.fetchMembers(
        AppStorageController.to.currentUser!.userID!,
        AppStorageController.to.currentUser!.companyID!,
        team.id!,
      ),
    )
        .catchError((e) {
      isMemberLoading.value = false;
    });
    if (resp != null && resp is Map<String, dynamic>) {
      members = MemberModel.fromJson(resp);
    } else {
      showErrorSnack((resp['errorMsg'] ?? resp).toString());
    }
    isMemberLoading.value = false;
  }

  Future<void> addTeam(String teamName) async {
    if (teamName.trim().isEmpty) {
      showErrorSnack("Enter Team Name");
      return;
    }
    final resp = await ApiController.to.callPOSTAPI(
      url: APIUrlsService.to.addTeam,
      body: {
        "userID": AppStorageController.to.currentUser?.userID,
        "companyID": AppStorageController.to.currentUser?.companyID,
        "teamName": teamName,
      },
    ).catchError((e) {
      closeDialogs();
      Get.defaultDialog(
        content: Text(e.toString()),
        onConfirm: closeDialogs,
        textConfirm: "ok",
      );
    });
    closeDialogs();
    if (resp.toString().contains("Team Created")) {
      fetchAllTeams();
    } else {
      Get.defaultDialog(
        content: Text(resp.toString()),
        onConfirm: closeDialogs,
        textConfirm: "ok",
      );
    }
  }

  Future<void> addMembers(
      String fullName, String username, UserRoleType selectedRole) async {
    if (username.trim().isEmpty ||
        fullName.trim().isEmpty ||
        (selectedTeam?.id == null)) {
      showErrorSnack("Enter Full Name and username and select team");
      return;
    }
    final resp = await ApiController.to.callPOSTAPI(
      url: APIUrlsService.to.addMember,
      body: {
        "creatingUserID": AppStorageController.to.currentUser?.userID,
        "fullName": fullName,
        "teamID": selectedTeam!.id!,
        "userName": username,
        "companyID": AppStorageController.to.currentUser?.companyID,
        "roleType": selectedRole.code,
      },
    ).catchError((e) {
      closeDialogs();
      Get.defaultDialog(
        content: Text(e.toString()),
        onConfirm: closeDialogs,
        textConfirm: "ok",
      );
    });
    closeDialogs();
    if (resp.toString().contains("Member Added")) {
      fetchAllTeams();
    } else {
      Get.defaultDialog(
        content: Text(resp.toString()),
        onConfirm: closeDialogs,
        textConfirm: "ok",
      );
    }
  }
}
