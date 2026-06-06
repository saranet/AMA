import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';

class UserActivityModel {
  String? activityID;
  String? createdAt;

  List<CheckIn>? checkIn;
  List<OutTime>? outTime;
  List<String>? breakInTime;
  List<String>? breakOutTime;

  UserActivityModel({
    this.activityID,
    this.createdAt,
    this.checkIn,
    this.outTime,
    this.breakInTime,
    this.breakOutTime,
  });

  UserActivityModel.fromJson(Map<String, dynamic> json) {
    activityID = json['activityID']?.toString();
    createdAt = json['date']?.toString();

    final checkInData = json['checkIn'];
    if (checkInData is List) {
      checkIn = checkInData.map((e) => CheckIn.fromJson(e)).toList();
    } else if (checkInData is Map) {
      checkIn = [CheckIn.fromJson(Map<String, dynamic>.from(checkInData))];
    }

    final outTimeData = json['outTime'];
    if (outTimeData is List) {
      outTime = outTimeData.map((e) => OutTime.fromJson(e)).toList();
    } else if (outTimeData is Map) {
      outTime = [OutTime.fromJson(Map<String, dynamic>.from(outTimeData))];
    }

    breakInTime =
        (json['breakInTime'] as List?)?.map((e) => e.toString()).toList();
    breakOutTime =
        (json['breakOutTime'] as List?)?.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['activityID'] = activityID;
    data['date'] = createdAt;
    if (checkIn != null) {
      data['checkIn'] = checkIn!.map((v) => v.toJson()).toList();
    }
    if (outTime != null) {
      data['outTime'] = outTime!.map((v) => v.toJson()).toList();
    }
    data['breakInTime'] = breakInTime;
    data['breakOutTime'] = breakOutTime;
    return data;
  }
}

class CheckIn {
  String? inTime;
  String? msg;

  CheckIn({this.inTime, this.msg});

  CheckIn.fromJson(Map<String, dynamic> json) {
    inTime = json['inTime']?.toString();
    msg = json['msg']?.toString();
  }

  Map<String, dynamic> toJson() => {
        'inTime': inTime,
        'msg': msg,
      };
}

class OutTime {
  String? outTime;
  String? msg;

  OutTime({this.outTime, this.msg});

  OutTime.fromJson(Map<String, dynamic> json) {
    outTime = json['outTime']?.toString();
    msg = json['msg']?.toString();
  }

  Map<String, dynamic> toJson() => {
        'outTime': outTime,
        'msg': msg,
      };
}

enum UserPerformActivty {
  IN,
  OUT,
  BREAKIN,
  BREAKOUT;

  // Using Get.context means no parameter needed — just use activity.label
  String get label {
    final l10n = AppLocalizations.of(Get.context!)!;
    return switch (this) {
      IN => l10n.swipeToCheckIn,
      BREAKIN => l10n.swipeToBreakIn,
      BREAKOUT => l10n.swipeToBreakOut,
      OUT => l10n.swipeToCheckOut,
    };
  }
}
