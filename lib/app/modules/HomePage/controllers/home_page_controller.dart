import 'dart:async';
import 'dart:math';
import 'package:ama/app/modules/Auth/model/AllowedZone.dart';
import 'package:ama/app/modules/Auth/services/AllowedZoneService.dart';
import 'package:ama/app/modules/Auth/services/ZoneStorageService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:ama/app/modules/Auth/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:ama/app/modules/HomePage/model/attendence_model.dart';
import 'package:ama/app/modules/HomePage/model/user_activity_model.dart';
import 'package:ama/data/controllers/api_conntroller.dart';
import 'package:ama/data/controllers/api_url_service.dart';
import 'package:ama/data/controllers/app_storage_service.dart';
import 'package:ama/utils/app_extensions.dart';
import 'package:ama/utils/helper_function.dart';
import 'package:intl/intl.dart';

class HomePageController extends GetxController {
  final authController = Get.find<AuthController>();
  bool available = false;
  var selectedDate = DateTime.now().obs;
  var attendenceLoading = true.obs, activityLoading = true.obs;
  var attendenceModel = Rxn<AttendenceModel?>(null);
  var userActivityModel = Rxn<UserActivityModel?>(null);
  var userPerformActivties =
      <UserPerformActivty>[].obs; // Was: userPerformActivty

  var now = DateTime.now();
  final RxList<AllowedZone> allowedZones = <AllowedZone>[].obs;
  final zoneService = Get.find<AllowedZoneService>();
  final inAllowedArea = false.obs;

  var workingTime = "".obs;
  Timer? _timer;

  @override
  void onInit() {
    available = authController.isBiometricAvailable.value;
    super.onInit();

    //checkUserLocation();
  }

  @override
  void onReady() {
    super.onReady();
    getAllData();
    // getActivityData();
  }

  void startTimer() {
    _timer?.cancel();

    final model = attendenceModel.value;
    if (model == null || model.inTimes == null || model.inTimes!.isEmpty) {
      workingTime.value = "00:00:00";
      return;
    }

    DateFormat format = DateFormat("HH:mm:ss");
    final now = DateTime.now();

    // ✅ Calculate ALL working hours from all sessions
    Duration totalWorking = Duration.zero;

    // Loop through all check-ins and check-outs
    for (int i = 0; i < model.inTimes!.length; i++) {
      if (i < (model.outTimes?.length ?? 0)) {
        try {
          var inTime = format.parse(model.inTimes![i]);
          var outTime = format.parse(model.outTimes![i]);
          totalWorking += outTime.difference(inTime);
        } catch (e) {
          print("Error parsing session $i: $e");
        }
      }
    }

    // ✅ Subtract all break times
    Duration totalBreak = Duration.zero;
    if (model.breakInTime != null &&
        model.breakOutTime != null &&
        model.breakInTime!.isNotEmpty &&
        model.breakOutTime!.isNotEmpty) {
      for (int i = 0; i < model.breakInTime!.length; i++) {
        if (i < model.breakOutTime!.length) {
          try {
            var breakIn = format.parse(model.breakInTime![i]);
            var breakOut = format.parse(model.breakOutTime![i]);
            totalBreak += breakOut.difference(breakIn);
          } catch (e) {
            print("Error parsing break $i: $e");
          }
        }
      }
    }

    // Check if user is still working (more check-ins than check-outs)
    final isStillWorking =
        (model.outTimes?.length ?? 0) < model.inTimes!.length;

    if (isStillWorking) {
      // User is still working - run timer
      final lastCheckInStr = model.inTimes!.last;
      final lastCheckInTime = _parseTimeString(lastCheckInStr, now);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        // Add current session duration
        final currentSessionDuration = now.difference(lastCheckInTime);
        final netWorking = totalWorking + currentSessionDuration - totalBreak;

        if (netWorking.isNegative) {
          workingTime.value = "00:00:00";
        } else {
          workingTime.value = netWorking.toString().split(".")[0];
        }
      });
    } else {
      // User checked out - just show total
      final netWorking = totalWorking - totalBreak;
      if (netWorking.isNegative) {
        workingTime.value = "00:00:00";
      } else {
        workingTime.value = netWorking.toString().split(".")[0];
      }
    }
  }

// ✅ Helper to parse time string into DateTime with today's date
  DateTime _parseTimeString(String timeStr, DateTime referenceDate) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(timeStr);
      return DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
      );
    } catch (e) {
      print("Error parsing time: $e");
      return DateTime.now();
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void onDateChnged(DateTime newDate) {
    selectedDate.value = newDate;

    getAllData();
    // getTodatyAttendenceData();
    //getActivityData();
  }

  void getAllData({
    Map<String, dynamic>? attendanceData,
    Map<String, dynamic>? activityData,
  }) {
    // If data is provided (from performInOut success), process it directly
    if (attendanceData != null && activityData != null) {
      attendenceLoading.value = false;
      activityLoading.value = false;

      attendenceModel.value = AttendenceModel.fromJson(attendanceData);
      getActivityData(activityData);
      startTimer();
      return;
    }

    // Original logic: Perform network call for initial load or date change
    var url = APIUrlsService.to.getDataByIDAndCompanyIdAndDate(
      AppStorageController.to.currentUser!.userID!,
      AppStorageController.to.currentUser!.companyID!,
      selectedDate.value.toYYYMMDD,
    );

    ApiController.to.callGETAPI(url: url).catchError((e) {
      showErrorSnack(e.toString());
      activityLoading.value = false;
      attendenceLoading.value = false;
      userPerformActivties.value = [
        UserPerformActivty.IN
      ]; // Default to IN on error
    }).then((resp) {
      attendenceLoading.value = false;
      activityLoading.value = false;
      if (resp is Map<String, dynamic> && resp['status'] == true) {
        attendenceModel.value = AttendenceModel.fromJson(resp['data']);
        startTimer();
        if (resp['activity'] is Map<String, dynamic>) {
          getActivityData(resp['activity']);
        }
      } else {
        // No Data or API error
        attendenceModel.value = null;
        userActivityModel.value = null;
        userPerformActivties.value = [UserPerformActivty.IN];
        stopTimer();
        if (resp is Map<String, dynamic>) {
          showErrorSnack(resp['errorMsg']?.toString() ?? "Unknown error.");
        }
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
    try {
      if (data.isEmpty) {
        userActivityModel.value = null;
        // FIX: If data is empty, the only available action is IN
        userPerformActivties.value = [UserPerformActivty.IN];
        return;
      }

      activityLoading.value = false;
      userActivityModel.value = UserActivityModel.fromJson(data);
      final model = userActivityModel.value;

      if (model == null) {
        userPerformActivties.value = [UserPerformActivty.IN];
        return;
      }
      userPerformActivties.clear();

      // Multi check-in/out logic (rest of the logic remains the same)
      final checkInCount = model.checkIn?.length ?? 0;
      final checkOutCount = model.outTime?.length ?? 0;
      final breakInCount = model.breakInTime?.length ?? 0;
      final breakOutCount = model.breakOutTime?.length ?? 0;

      // Simple flow: Check In → Break In → Break Out → Check Out
      if (checkInCount == 0) {
        userPerformActivties.add(UserPerformActivty.IN);
      } else if (checkInCount > checkOutCount) {
        if (breakInCount > breakOutCount) {
          userPerformActivties.add(UserPerformActivty.BREAKOUT);
        } else {
          userPerformActivties.add(UserPerformActivty.BREAKIN);
          userPerformActivties.add(UserPerformActivty.OUT);
        }
      } else if (checkInCount == checkOutCount) {
        userPerformActivties.add(UserPerformActivty.IN);
      } else {
        userPerformActivties.add(UserPerformActivty.IN);
      }
    } catch (e, st) {
      print("Error parsing activity data: $e\n$st");
      userActivityModel.value = null;
      activityLoading.value = false;
      // FIX: If parsing fails, allow the user to check in
      userPerformActivties.value = [UserPerformActivty.IN];
    }
  }

  void performInOut(UserPerformActivty activity) async {
    if (activityLoading.value) return;
    activityLoading.value = true;

    final position = await getCurrentPosition();
    if (position == null) {
      activityLoading.value = false;
      return;
    }

    final canCheckIn = zoneService.isWithinAllowedZone(position);

    if (!canCheckIn) {
      Get.snackbar(
          "Attendance Blocked", "You are outside allowed attendance zone ❌",
          backgroundColor: Colors.red.shade400, colorText: Colors.white);
      activityLoading.value = false;
      return;
    }

    // Build payload body
    final nowStr = DateTime.now().toHOUR24MINUTESECOND;
    var payload = {
      "activityID": userActivityModel.value?.activityID,
      "userID": AppStorageController.to.currentUser?.userID,
      "companyID": AppStorageController.to.currentUser?.companyID,
      "activityType": activity.name,
    };
    if (activity == UserPerformActivty.IN) {
      payload.putIfAbsent("inTime", () => nowStr);
    } else if (activity == UserPerformActivty.BREAKIN) {
      payload.putIfAbsent("breakInTime", () => nowStr);
    } else if (activity == UserPerformActivty.BREAKOUT) {
      payload.putIfAbsent("breakOutTime", () => nowStr);
    } else if (activity == UserPerformActivty.OUT) {
      payload.putIfAbsent("outTime", () => nowStr);
    }

    bool sentOnline = false;
    Map<String, dynamic>? resp;
    // print("payload: $payload");
    try {
      resp = await ApiController.to
          .callPOSTAPI(url: APIUrlsService.to.dailyInOut, body: payload);
      if (resp != null &&
          resp is Map<String, dynamic> &&
          resp['status'] == true) {
        sentOnline = true;
      } else {
        showErrorSnack("Server response error: $resp");
      }
    } catch (e) {
      showErrorSnack("Network/API error when sending attendance: $e");
    }

    if (sentOnline) {
      showSuccessSnack("Attendance recorded.");

      if (resp!['data'] != null && resp['activity'] != null) {
        getAllData(
          attendanceData: resp['data'] as Map<String, dynamic>,
          activityData: resp['activity'] as Map<String, dynamic>,
        );
      } else {
        getAllData();
      }
    } /*else {
      // Save to offline queue
      await offlineService.queueAttendance(
        activityType: activity.name,
        time: nowStr,
        lat: position.latitude,
        lng: position.longitude,
        extra: {
          "activityID": userActivityModel.value?.activityID,
        },
      );
      showSuccessSnack("Attendance saved locally. It will sync when online.");
      // Full refresh is needed here since we didn't get the updated state from the server
      getAllData();
    }*/

    activityLoading.value = false;
  }

  Duration calculateTotalBreakTime(
      List<String> inTimes, List<String> outTimes) {
    Duration totalBreakTime = Duration.zero;
    DateFormat format = DateFormat("HH:mm:ss");

    for (int i = 0; i < inTimes.length && i < outTimes.length; i++) {
      DateTime inTime = format.parse(inTimes[i]);
      DateTime outTime = format.parse(outTimes[i]);
      totalBreakTime += outTime.difference(inTime);
    }

    return totalBreakTime;
  }

  String? calculateTimeDifference(
      List<String>? inTimes, List<String>? outTimes) {
    if ((inTimes?.isEmpty ?? true) || (outTimes?.isEmpty ?? true)) {
      return null;
    }

    var times = mergeBreakInBreakOutTimes(inTimes!, outTimes!);
    print(times);

    Duration totalDuration = Duration.zero;
    if (times.length < 2) {
      // If there are less than two elements, return zero duration
      return secondsToTime(totalDuration.inSeconds);
    }
    DateFormat format = DateFormat("HH:mm:ss");
    //i=2
    for (int i = 0; i < times.length - 1; i = i + 2) {
      print("$i ${times.length}");
      if (i > times.length) {
        break;
      }
      DateTime currentTime = format.parse(times[i]);
      DateTime nextTime = format.parse(times[i + 1]);
      totalDuration += nextTime.difference(currentTime);
    }
    return secondsToTime(totalDuration.inSeconds);
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }

  int get countWorkingDays {
    int count = 0;
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;

    int totalDaysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;

    for (int day = 1; day <= totalDaysInMonth; day++) {
      var currentDate = DateTime(currentYear, currentMonth, day).toWEEKDAY;
      if (AppStorageController.to.currentUser!.wrokingDays!
          .contains(currentDate.toUpperCase())) {
        count++;
      }
    }

    return count;
  }

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorSnack("Location services are disabled.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorSnack("Location permission denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showErrorSnack("Location permission permanently denied.");
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> checkUserLocation() async {
    final position = await getCurrentPosition();
    if (position != null) {
      inAllowedArea.value = zoneService.isWithinAllowedZone(position);
    } else {
      inAllowedArea.value = false;
    }
  }
}
