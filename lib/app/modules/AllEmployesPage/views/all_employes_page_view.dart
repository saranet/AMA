import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/models/teams_model.dart';
import 'package:ama/data/app_enums.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/theme/app_colors.dart';
import 'package:ama/widgets/app_textfield.dart';
import 'package:ama/l10n/app_localizations.dart';
import '../controllers/all_employes_page_controller.dart';

class AllEmployesPageView extends GetView<AllEmployesPageController> {
  const AllEmployesPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      l10n.attendanceReport,
                      style: Get.textTheme.headlineSmall,
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: controller.fetchAllTeams,
                        icon: const Icon(Icons.refresh)),
                    Builder(builder: (context) {
                      final role =
                          AppStorageController.to.currentUser?.roleType;
                      if (role == UserRoleType.watcher ||
                          role == UserRoleType.employee ||
                          role == UserRoleType.manager ||
                          role == null) {
                        return const SizedBox();
                      }
                      return IconButton(
                        onPressed: () => addTeamDialog(context),
                        icon: const Icon(Icons.people),
                      );
                    })
                  ],
                ),
              ),
              8.width,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  l10n.departmentEmployeesList,
                  style: Get.textTheme.titleMedium,
                ),
              ),
              4.height,
              Obx(
                () {
                  if (controller.isTeamLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.teams.isEmpty) {
                    return Center(
                      child: Text(l10n.noTeamsFound),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.teams.length,
                    itemBuilder: (context, index) => _buildTeamItem(index),
                  );
                },
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  void addTeamDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String teamname = "";
    Get.defaultDialog(
      title: l10n.addTeam,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            hintText: l10n.teamName,
            onChanged: (p) => teamname = p,
          )
        ],
      ),
      textCancel: l10n.cancel,
      onConfirm: () => controller.addTeam(teamname),
      textConfirm: l10n.addTeam,
    );
  }

  void addMembersDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String fullName = "", username = "";
    UserRoleType selectedRole = UserRoleType.watcher;
    TeamsModel selectedTeam = controller.teams.first;

    List<String> list = List.from(UserRoleType.list);
    if (AppStorageController.to.currentUser?.roleType ==
        UserRoleType.superAdmin) {
      list.removeWhere((element) => element == UserRoleType.superAdmin.code);
    }
    if (AppStorageController.to.currentUser?.roleType == UserRoleType.admin) {
      list.removeWhere((element) => element == UserRoleType.superAdmin.code);
      list.removeWhere((element) => element == UserRoleType.admin.code);
    }
    Get.defaultDialog(
      title: l10n.addMember,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            hintText: l10n.fullName,
            onChanged: (p) => fullName = p,
          ),
          8.height,
          AppTextField(
            hintText: l10n.email,
            onChanged: (p) => username = p,
          ),
          8.height,
          //? TEAMS
          StatefulBuilder(builder: (context, s) {
            return DropdownButton<TeamsModel>(
              items: controller.teams
                  .map(
                    (e) => DropdownMenuItem<TeamsModel>(
                      value: e,
                      child: Text(e.teamName ?? "?"),
                    ),
                  )
                  .toList(),
              value: selectedTeam,
              onChanged: (a) {
                selectedTeam = a!;
                s(() {});
              },
            );
          }),
          8.height,
          //? ROLE
          StatefulBuilder(builder: (context, s) {
            return DropdownButton(
              items: list
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              value: selectedRole.code,
              onChanged: (a) {
                selectedRole = UserRoleType.fromString(a!);
                s(() {});
              },
            );
          })
        ],
      ),
      textCancel: l10n.cancel,
      onConfirm: () => controller.addMembers(fullName, username, selectedRole),
      textConfirm: l10n.addMember,
    );
  }

  Widget _buildTeamItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: InkWell(
        onTap: () => controller.onTeamTap(controller.teams[index]),
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: AppColors.kGrey100,
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
            border: Border.all(
              width: controller.teams[index].id == controller.selectedTeam?.id
                  ? 1
                  : 0,
              color: controller.teams[index].id == controller.selectedTeam?.id
                  ? AppColors.kBlue900
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(controller.teams[index].teamName ?? "-")),
              if (controller.teams[index].id ==
                  controller.selectedTeam?.id) ...[
                16.width,
                const Icon(Icons.check),
                16.width,
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Ink(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.kGrey100,
          borderRadius: BorderRadius.circular(12),
          shape: BoxShape.rectangle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: double.maxFinite),
            Text(controller.members?.members?[index].fullName ?? "-"),
            Text(controller.members?.members?[index].userName ?? "-"),
            Text(controller.members?.members?[index].roleType ?? "-"),
          ],
        ),
      ),
    );
  }
}
