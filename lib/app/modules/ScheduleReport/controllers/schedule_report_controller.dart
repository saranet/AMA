import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/models/teams_model.dart';
import 'package:ama/app/modules/ScheduleReport/model/schedule_model.dart';

import '../../../../data/controllers/api_conntroller.dart';
import '../../../../data/controllers/api_url_service.dart';
import '../../../../data/controllers/app_storage_service.dart';
import '../../../../utils/helper_function.dart';

class ScheduleReportController extends GetxController {
  //TODO: Implement ScheduleReportController
  var myData = false.obs;
  final count = 0.obs;
  var totalCount = {}.obs;
  var scheduleModel = <ScheduleModel>[].obs;
  var mainList = <ScheduleModel>[].obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getAllSchedules();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void myDataChanged(bool value) {
    myData.value = value;
    getAllSchedules();
  }

  void getAllSchedules() async {
    print("parameters ${AppStorageController.to.currentUser!.userID!}, "
        "${AppStorageController.to.currentUser!.companyID!}, "
        "${AppStorageController.to.currentUser!.departmentID!}, "
        "${AppStorageController.to.currentUser!.roleType!.code}, "
        "${myData.value}");
    ApiController.to
        .callGETAPI(
      url: APIUrlsService.to.getAllSchedules(
        AppStorageController.to.currentUser!.userID!,
        AppStorageController.to.currentUser!.companyID!,
        AppStorageController.to.currentUser!.departmentID!,
        AppStorageController.to.currentUser!.roleType!.code,
        myData.value,
      ),
    )
        .then((resp) {
      scheduleModel.clear();
      mainList.clear();
      if (resp != null && resp['resp_status']) {
        if (resp['data'] is List<dynamic>) {
          scheduleModel.addAll(
            (resp['data'] as List<dynamic>)
                .map((e) => ScheduleModel.fromJson(e))
                .toList(),
          );
        } else {
          mainList.addAll(
            (resp['data']['data'] as List<dynamic>)
                .map((e) => ScheduleModel.fromJson(e))
                .toList(),
          );
        }
      } else if (resp["errorMsg"] != "No Data") {
        showErrorSnack(resp["errorMsg"].toString());
      }
    }).catchError(
      (e) {
        print("Error: ${e.toString()}");
        showErrorSnack(e.toString());
      },
    );
  }

  void increment() => count.value++;
}
