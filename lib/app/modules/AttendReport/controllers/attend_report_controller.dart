import 'dart:async';

import 'package:ama/app/modules/HomePage/model/attendence_model.dart';
import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/app/routes/app_pages.dart';
import 'package:get/get.dart';

import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:intl/intl.dart';

class AttendReportController extends GetxController {
  //TODO: Implement AttendReportController
  var selectedDate = DateTime.now().obs;
  var attendenceLoading = true.obs, activityLoading = true.obs;
  var attendenceModel = Rxn<AttendenceModel?>(null);
  var userActivityModel = Rxn<UserActivityModel?>(null);
  var userPerformActivty = UserPerformActivty.IN.obs;
  var now = DateTime.now();
  var workingTime = "".obs;
  Timer? _timer;
  final userId = Get.parameters['userId'];
  final userName = Get.parameters['userName'] ?? "User";
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getAllData(userId!);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goBack() {
    if (Get.previousRoute.isEmpty) {
      Get.offAllNamed(AppPages.INITIAL);
    } else {
      Get.back();
    }
  }

  void onDateChnged(DateTime newDate) {
    selectedDate.value = newDate;

    getAllData(userId!);
    // getTodatyAttendenceData();
    //getActivityData();
  }

  void getAllData(String userId) {
    var url = APIUrlsService.to.getDataByIDAndCompanyIdAndDate(
      userId!,
      AppStorageController.to.currentUser!.companyID!,
      selectedDate.value.toYYYMMDD,
    );
    print("selectedDate.value.toYYYMMDD: ${selectedDate.value.toYYYMMDD}");
    ApiController.to
        .callGETAPI(
      url: url,
    )
        .catchError((e) {
      showErrorSnack(e.toString());
      activityLoading.value = false;
      attendenceLoading.value = false;
    }).then((resp) {
      attendenceLoading.value = false;
      activityLoading.value = false;
      if (resp is Map<String, dynamic>) {
        if (resp['status'] == true) {
          print("respYYYYYYY: $resp");
          // attendenceModel.value = AttendenceModel.fromJson(
          //resp['data'].first as Map<String, dynamic>);
          attendenceModel.value = AttendenceModel.fromJson(resp['data']);

          ///////get Activity Data ///////////////////
          if (resp['activity'] != null) {
            getActivityData(resp['activity'] as Map<String, dynamic>);
          } else {
            userActivityModel.value = null;
            showErrorSnack(resp['errorMsg']?.toString() ?? "Unknown error.");
          }
        } else {
          //no Data
          attendenceModel.value = null;
          userActivityModel.value = null;

          //showErrorSnack(resp['errorMsg']?.toString() ?? "Unknown error.");
        }
      } else {
        attendenceModel.value = null;
        userActivityModel.value = null;
        showErrorSnack("Invalid API response format.");
      }
    });
  }

  String get calculateTotalWorkingHours {
    if (attendenceModel.value?.inTimes == null ||
        attendenceModel.value?.outTimes == null) {
      return "00:00:00";
    }

    Duration total = Duration.zero;
    DateFormat format = DateFormat("HH:mm:ss");

    for (int i = 0;
        i < attendenceModel.value!.inTimes!.length &&
            i < attendenceModel.value!.outTimes!.length;
        i++) {
      var inTime = format.parse(attendenceModel.value!.inTimes![i]);
      var outTime = format.parse(attendenceModel.value!.outTimes![i]);
      total += outTime.difference(inTime);
    }

    return total.toString().split(".")[0];
  }

  void getActivityData(Map<String, dynamic> data) {
//    if (data == null) userActivityModel.value = null;
    // print("getActivityData: $data");
    if (data != null) {
      activityLoading.value = false;
      userActivityModel.value = UserActivityModel.fromJson(data);
      if (userActivityModel.value?.checkIn == null) {
        userPerformActivty.value = UserPerformActivty.IN;
      } else if (userActivityModel.value?.breakInTime == null ||
          (userActivityModel.value?.breakInTime?.isEmpty ?? true)) {
        userPerformActivty.value = UserPerformActivty.BREAKIN;
      } else if (userActivityModel.value?.breakOutTime == null ||
          ((userActivityModel.value?.breakInTime?.length ?? 0) >
              ((userActivityModel.value?.breakOutTime?.length ?? 0)))) {
        userPerformActivty.value = UserPerformActivty.BREAKOUT;
      } else if (userActivityModel.value?.outTime == null) {
        userPerformActivty.value = UserPerformActivty.BREAKIN;
      }
    } else {
      userActivityModel.value = null;
    }
  }

  void increment() => count.value++;
}
