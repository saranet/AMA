import 'package:ama/app/modules/ScheduleReport/views/schedule_report_view.dart';
import 'package:ama/app/modules/SchedulesPage/controllers/schedules_page_controller.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ama/app/modules/AllEmployesPage/bindings/all_employes_page_binding.dart';
import 'package:ama/app/modules/AllEmployesPage/views/all_employes_page_view.dart';
import 'package:ama/app/modules/HolidayPage/bindings/holiday_page_binding.dart';
import 'package:ama/app/modules/HolidayPage/views/holiday_page_view.dart';
import 'package:ama/app/modules/HomePage/bindings/home_page_binding.dart';
import 'package:ama/app/modules/HomePage/views/home_page_view.dart';
import 'package:ama/app/modules/LeavePage/bindings/leave_page_binding.dart';
import 'package:ama/app/modules/LeavePage/views/leave_page_view.dart';
import 'package:ama/app/modules/ProfilePage/bindings/profile_page_binding.dart';
import 'package:ama/app/modules/ProfilePage/views/profile_page_view.dart';
import 'package:ama/app/modules/SchedulesPage/bindings/schedules_page_binding.dart';
import 'package:ama/app/modules/SchedulesPage/views/schedules_page_view.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/helper_function.dart';

import '../../ScheduleReport/bindings/schedule_report_binding.dart';
import '../../ScheduleReport/controllers/schedule_report_controller.dart';

class DashboardPageController extends GetxController {
  List<Widget> pages = [];
  var currentIndex = 0.obs;

  Map<int, bool> canPageLoad = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false, // all team leave
  };
  @override
  void onInit() {
    super.onInit();
    canPageLoad[currentIndex.value] = true;
    HomePageBinding().dependencies();
    pages = [
      const HomePageView(),
      const SizedBox(),
      const SizedBox(),
      const SizedBox(),
      const SizedBox(),
    ];
  }

  onBottomNavTap(int newIndex) {
    print(newIndex);
    if (newIndex == currentIndex.value) return;
    if (!(canPageLoad[newIndex]!)) {
      canPageLoad[newIndex] = true;
      if (newIndex == 1) {
        pages.removeAt(newIndex);
        LeavePageBinding().dependencies();
        pages.insert(newIndex, const LeavePageView());
      }
      if (newIndex == 2) {
        //Get.delete<ScheduleReportController>();
        pages.removeAt(newIndex);
        ScheduleReportBinding().dependencies();
        pages.insert(newIndex, const ScheduleReportView());

        // HolidayPageBinding().dependencies();
        // pages.insert(newIndex, const HolidayPageView());
      }
      if (newIndex == 3) {
        pages.removeAt(newIndex);
        ProfilePageBinding().dependencies();
        pages.insert(newIndex, const ProfilePageView());
      }
    }
    currentIndex.value = newIndex;
  }

  void onFloatTap() {
    if (!(canPageLoad[4]!)) {
      pages.removeAt(4);
      AllEmployesPageBinding().dependencies();
      pages.insert(4, const AllEmployesPageView());
    }
    currentIndex.value = 4;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void checkUserIsApproved() {
    ApiController.to
        .callGETAPI(
      url: APIUrlsService.to.getDataByIDAndCompanyIdAndDate(
        AppStorageController.to.currentUser!.userID!,
        AppStorageController.to.currentUser!.companyID!,
        DateTime.now().toYYYMMDD,
      ),
    )
        .catchError((e) {
      showErrorSnack(e.toString());
    }).then((resp) async {
      if (resp is Map<String, dynamic> &&
          resp['errorMsg'] != "Your account is not active") {
        AppStorageController.to.currentUser?.employeeApproved = true;
        AppStorageController.to
            .saveUserData(AppStorageController.to.currentUser!.toJson());
        update(['rootUI']);
      } else {
        showErrorSnack(resp['errorMsg'].toString());
      }
      print(resp);
    });
  }
}
