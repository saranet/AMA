import 'dart:async';
import 'package:ama/app/modules/Auth/model/AllowedZone.dart';
import 'package:ama/app/modules/Auth/services/AllowedZoneService.dart';
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
import 'package:ama/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomePageController extends GetxController {
  static final _timeFormat = DateFormat("HH:mm:ss");
  final authController = Get.find<AuthController>();
  bool available = false;
  var selectedDate = DateTime.now().obs;
  var attendenceLoading = true.obs, activityLoading = true.obs;
  var attendenceModel = Rxn<AttendenceModel?>(null);
  var userActivityModel = Rxn<UserActivityModel?>(null);
  var userPerformActivties = <UserPerformActivty>[].obs;

  // ✅ Tracks if a swipe action is being processed (blocks duplicates)
  var isPerformingAction = false.obs;

  var now = DateTime.now();
  final RxList<AllowedZone> allowedZones = <AllowedZone>[].obs;
  final zoneService = Get.find<AllowedZoneService>();
  final inAllowedArea = false.obs;

  var workingTime = "".obs;
  Timer? _timer;

  // ✅ GPS cache to speed up swipes
  Position? _lastKnownPosition;
  DateTime? _lastPositionTime;
  static const _positionCacheDuration = Duration(seconds: 30);

  AppLocalizations get l10n => AppLocalizations.of(Get.context!)!;

  @override
  void onInit() {
    available = authController.isBiometricAvailable.value;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getAllData();
  }

  // ── TIMER (FIXED — no more 1-hour offset) ──────────────────────────────────

  void startTimer() {
    _timer?.cancel();

    final model = attendenceModel.value;
    if (model == null || model.inTimes == null || model.inTimes!.isEmpty) {
      workingTime.value = "00:00:00";
      return;
    }

    final today = DateTime.now();

    // Parse server time string (UTC+3 Asia/Riyadh) → device local DateTime
    DateTime parseTime(String timeStr) {
      final parts = timeStr.split(':');
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final s = parts.length > 2 ? int.parse(parts[2]) : 0;
      // Build a UTC instant by treating the server value as UTC+3, then convert to local
      return DateTime.utc(today.year, today.month, today.day, h, m, s)
          .subtract(const Duration(hours: 3))
          .toLocal();
    }

    Duration totalWorking = Duration.zero;
    for (int i = 0; i < model.inTimes!.length; i++) {
      if (i < (model.outTimes?.length ?? 0)) {
        try {
          final inTime = parseTime(model.inTimes![i]);
          final outTime = parseTime(model.outTimes![i]);
          totalWorking += outTime.difference(inTime);
        } catch (e) {
            }
      }
    }

    Duration totalBreak = Duration.zero;
    if (model.breakInTime != null &&
        model.breakOutTime != null &&
        model.breakInTime!.isNotEmpty &&
        model.breakOutTime!.isNotEmpty) {
      for (int i = 0; i < model.breakInTime!.length; i++) {
        if (i < model.breakOutTime!.length) {
          try {
            final breakIn = parseTime(model.breakInTime![i]);
            final breakOut = parseTime(model.breakOutTime![i]);
            totalBreak += breakOut.difference(breakIn);
          } catch (e) {
            }
        }
      }
    }

    final isStillWorking =
        (model.outTimes?.length ?? 0) < model.inTimes!.length;

    if (isStillWorking) {
      final lastCheckInStr = model.inTimes!.last;
      final lastCheckInTime = parseTime(lastCheckInStr);

      // ✅ Get fresh DateTime.now() inside timer callback
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final currentSessionDuration = now.difference(lastCheckInTime);
        final netWorking = totalWorking + currentSessionDuration - totalBreak;

        if (netWorking.isNegative) {
          workingTime.value = "00:00:00";
        } else {
          workingTime.value = _formatDuration(netWorking);
        }
      });
    } else {
      final netWorking = totalWorking - totalBreak;
      if (netWorking.isNegative) {
        workingTime.value = "00:00:00";
      } else {
        workingTime.value = _formatDuration(netWorking);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // ── DATA LOADING ───────────────────────────────────────────────────────────

  void onDateChnged(DateTime newDate) {
    selectedDate.value = newDate;
    getAllData();
  }

  void getAllData({
    Map<String, dynamic>? attendanceData,
    Map<String, dynamic>? activityData,
  }) {
    // ✅ Use response data directly if provided (no extra API call)
    if (attendanceData != null && activityData != null) {
      attendenceLoading.value = false;
      activityLoading.value = false;

      attendenceModel.value = AttendenceModel.fromJson(attendanceData);
      getActivityData(activityData);
      startTimer();
      return;
    }

    var url = APIUrlsService.to.getDataByIDAndCompanyIdAndDate(
      AppStorageController.to.currentUser!.userID!,
      AppStorageController.to.currentUser!.companyID!,
      selectedDate.value.toYYYMMDD,
    );

    ApiController.to.callGETAPI(url: url).then((resp) {
      attendenceLoading.value = false;
      activityLoading.value = false;
      if (resp is Map<String, dynamic> && resp['status'] == true) {
        attendenceModel.value = AttendenceModel.fromJson(resp['data']);
        startTimer();
        if (resp['activity'] is Map<String, dynamic>) {
          getActivityData(resp['activity']);
        }
      } else {
        attendenceModel.value = null;
        userActivityModel.value = null;
        userPerformActivties.value = [UserPerformActivty.IN];
        stopTimer();
      }
    }).catchError((e) {
      activityLoading.value = false;
      attendenceLoading.value = false;
      userPerformActivties.value = [UserPerformActivty.IN];
    });
  }

  String get calculateTotalWorkingHours {
    if (attendenceModel.value?.inTimes == null ||
        attendenceModel.value?.outTimes == null) {
      return "00:00:00";
    }

    Duration total = Duration.zero;
    for (int i = 0;
        i < attendenceModel.value!.inTimes!.length &&
            i < attendenceModel.value!.outTimes!.length;
        i++) {
      final inTime = _timeFormat.parse(attendenceModel.value!.inTimes![i]);
      final outTime = _timeFormat.parse(attendenceModel.value!.outTimes![i]);
      total += outTime.difference(inTime);
    }

    return _formatDuration(total);
  }

  void getActivityData(Map<String, dynamic> data) {
    try {
      if (data.isEmpty) {
        userActivityModel.value = null;
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

      final checkInCount = model.checkIn?.length ?? 0;
      final checkOutCount = model.outTime?.length ?? 0;
      final breakInCount = model.breakInTime?.length ?? 0;
      final breakOutCount = model.breakOutTime?.length ?? 0;

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
    } catch (_) {
      userActivityModel.value = null;
      activityLoading.value = false;
      userPerformActivties.value = [UserPerformActivty.IN];
    }
  }

  // ── PERFORM IN/OUT (FAST + DUPLICATE-PROOF) ───────────────────────────────

  /// Get GPS position fast — uses 30-second cache
  Future<Position?> _getCachedPosition() async {
    if (_lastKnownPosition != null && _lastPositionTime != null) {
      final age = DateTime.now().difference(_lastPositionTime!);
      if (age < _positionCacheDuration) {
          return _lastKnownPosition;
      }
    }

    final pos = await getCurrentPosition();
    if (pos != null) {
      _lastKnownPosition = pos;
      _lastPositionTime = DateTime.now();
    }
    return pos;
  }

  void performInOut(UserPerformActivty activity) async {
    // ✅ Block duplicate calls
    if (isPerformingAction.value) {
      //print('⚠️ Action already in progress — ignoring duplicate swipe');
      return;
    }

    isPerformingAction.value = true;

    try {
      // ✅ Use cached GPS to skip 1-2 second wait
      final position = await _getCachedPosition();
      if (position == null) {
        return;
      }

      if (!zoneService.isWithinAllowedZone(position)) {
        Get.snackbar(
          l10n.attendanceBlocked,
          l10n.youAreOutsideAllowedAttendanceZone,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
        return;
      }

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

      try {
        final resp = await ApiController.to
            .callPOSTAPI(url: APIUrlsService.to.dailyInOut, body: payload);

        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['status'] == true) {
          showSuccessSnack(l10n.attendanceRecorded);

          // ✅ Use response data directly — no second API call!
          if (resp['data'] != null && resp['activity'] != null) {
            getAllData(
              attendanceData: resp['data'] as Map<String, dynamic>,
              activityData: resp['activity'] as Map<String, dynamic>,
            );
          } else {
            getAllData();
          }
        } else {
          final errMsg = resp is Map
              ? (resp['errorMsg']?.toString() ?? l10n.unknownError)
              : l10n.unknownError;
          showErrorSnack(errMsg);
        }
      } catch (e) {
        showErrorSnack(e.toString());
      }
    } finally {
      // ✅ ALWAYS reset — even on errors
      isPerformingAction.value = false;
    }
  }

  // ── HELPERS ────────────────────────────────────────────────────────────────

  Duration calculateTotalBreakTime(
      List<String> inTimes, List<String> outTimes) {
    Duration totalBreakTime = Duration.zero;
    for (int i = 0; i < inTimes.length && i < outTimes.length; i++) {
      final inTime = _timeFormat.parse(inTimes[i]);
      final outTime = _timeFormat.parse(outTimes[i]);
      totalBreakTime += outTime.difference(inTime);
    }
    return totalBreakTime;
  }

  String? calculateTimeDifference(
      List<String>? inTimes, List<String>? outTimes) {
    if ((inTimes?.isEmpty ?? true) || (outTimes?.isEmpty ?? true)) {
      return null;
    }

    final times = mergeBreakInBreakOutTimes(inTimes!, outTimes!);
    Duration totalDuration = Duration.zero;
    if (times.length < 2) {
      return secondsToTime(totalDuration.inSeconds);
    }
    for (int i = 0; i < times.length - 1; i = i + 2) {
      if (i > times.length) break;
      final currentTime = _timeFormat.parse(times[i]);
      final nextTime = _timeFormat.parse(times[i + 1]);
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

  // ── LOCATION ───────────────────────────────────────────────────────────────

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorSnack(l10n.locationServicesAreDisabled);
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showErrorSnack(l10n.locationPermissionDenied);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showErrorSnack(l10n.locationPermissionPermanentlyDenied);
      return null;
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10));
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
